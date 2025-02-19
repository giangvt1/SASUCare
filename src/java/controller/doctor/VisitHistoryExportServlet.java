package controller.doctor;

import dao.CustomerDBContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.VisitHistory;
import org.apache.poi.ss.usermodel.*;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import java.io.IOException;
import java.io.OutputStream;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.util.ArrayList;

@WebServlet(name = "VisitHistoryExportServlet", urlPatterns = {"/exportVisitHistory"})
public class VisitHistoryExportServlet extends HttpServlet {

    private static final int COLUMN_INDEX = 0;
    private static final int COLUMN_VISIT_DATE = 1;
    private static final int COLUMN_REASON_FOR_VISIT = 2;
    private static final int COLUMN_DIAGNOSES = 3;
    private static final int COLUMN_TREATMENT_PLAN = 4;
    private static final int NEXT_APPOINTMENT = 5;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int cId = Integer.parseInt(request.getParameter("cId"));
        String currentPageStr = request.getParameter("pageVisit");
        String sizeOfEachTableStr = request.getParameter("sizevisit");

        int currentPage = (currentPageStr != null && !currentPageStr.isEmpty()) ? Integer.parseInt(currentPageStr) : 1;
        int sizeOfEachTable = (sizeOfEachTableStr != null && !sizeOfEachTableStr.isEmpty()) ? Integer.parseInt(sizeOfEachTableStr) : 10;

        CustomerDBContext customerDB = new CustomerDBContext();
        ArrayList<VisitHistory> visitHistory = customerDB.getVisitHistoriesByCustomerIdPaginated(cId, currentPage, sizeOfEachTable);

        try (Workbook workbook = new XSSFWorkbook()) {
            Sheet sheet = workbook.createSheet("Visit Histories");

            // Định dạng tiêu đề
            CellStyle headerStyle = workbook.createCellStyle();
            Font headerFont = workbook.createFont();
            headerFont.setBold(true);
            headerStyle.setFont(headerFont);
            headerStyle.setAlignment(HorizontalAlignment.CENTER);
            headerStyle.setFillForegroundColor(IndexedColors.LIGHT_YELLOW.getIndex());
            headerStyle.setFillPattern(FillPatternType.SOLID_FOREGROUND);
            headerStyle.setBorderBottom(BorderStyle.THIN);
            headerStyle.setBorderTop(BorderStyle.THIN);
            headerStyle.setBorderLeft(BorderStyle.THIN);
            headerStyle.setBorderRight(BorderStyle.THIN);

            // Định dạng dữ liệu
            CellStyle dataStyle = workbook.createCellStyle();
            dataStyle.setBorderBottom(BorderStyle.THIN);
            dataStyle.setBorderTop(BorderStyle.THIN);
            dataStyle.setBorderLeft(BorderStyle.THIN);
            dataStyle.setBorderRight(BorderStyle.THIN);

            // Tạo dòng tiêu đề
            Row headerRow = sheet.createRow(0);
            String[] headers = {"#", "Visit Date", "Reason For Visit", "Diagnoses", "Treatment Plan", "Next Appointment"};
            for (int i = 0; i < headers.length; i++) {
                Cell cell = headerRow.createCell(i);
                cell.setCellValue(headers[i]);
                cell.setCellStyle(headerStyle);
            }

            // Định dạng ngày tháng
            SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");

            // Ghi dữ liệu
            int rowIndex = 1; // Bắt đầu từ dòng 1 vì dòng 0 là tiêu đề
            for (VisitHistory history : visitHistory) {
                Row row = sheet.createRow(rowIndex++);
                Cell cellId = row.createCell(COLUMN_INDEX);
                cellId.setCellValue(rowIndex - 1); // Đặt giá trị index đúng
                cellId.setCellStyle(dataStyle);

                Cell cellVisitDate = row.createCell(COLUMN_VISIT_DATE);
                if (history.getVisitDate() != null) {
                    cellVisitDate.setCellValue(dateFormat.format(history.getVisitDate())); // Định dạng ngày tháng
                } else {
                    cellVisitDate.setCellValue("Invalid Date"); // Hoặc một thông báo hợp lý
                }
                cellVisitDate.setCellStyle(dataStyle);

                Cell cellReasonForVisit = row.createCell(COLUMN_REASON_FOR_VISIT);
                cellReasonForVisit.setCellValue(history.getReasonForVisit());
                cellReasonForVisit.setCellStyle(dataStyle);

                Cell cellDiagnoses = row.createCell(COLUMN_DIAGNOSES);
                cellDiagnoses.setCellValue(history.getDiagnoses());
                cellDiagnoses.setCellStyle(dataStyle);

                Cell cellTreatmentPlan = row.createCell(COLUMN_TREATMENT_PLAN);
                cellTreatmentPlan.setCellValue(history.getTreatmentPlan());
                cellTreatmentPlan.setCellStyle(dataStyle);

                Cell cellNextAppointment = row.createCell(NEXT_APPOINTMENT);
                if (history.getNextAppointment() != null) {
                    cellNextAppointment.setCellValue(dateFormat.format(history.getNextAppointment())); // Định dạng ngày tháng
                } else {
                    cellNextAppointment.setCellValue("No Appointment"); // Hoặc một thông báo hợp lý
                }
                cellNextAppointment.setCellStyle(dataStyle);
            }

            // Tự động điều chỉnh độ rộng cột
            for (int i = 0; i < headers.length; i++) {
                sheet.autoSizeColumn(i);
            }

            // Thiết lập HTTP response headers
            response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
            response.setHeader("Content-Disposition", "attachment; filename=visit_histories_page_" + currentPage + ".xlsx");

            // Ghi workbook vào output stream
            try (OutputStream out = response.getOutputStream()) {
                workbook.write(out);
            }
        }
    }
}
