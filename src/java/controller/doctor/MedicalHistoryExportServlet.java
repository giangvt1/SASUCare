package controller.doctor;

import dao.CustomerDBContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.MedicalHistory;
import org.apache.poi.ss.usermodel.*;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import java.io.IOException;
import java.io.OutputStream;
import java.util.ArrayList;

public class MedicalHistoryExportServlet extends HttpServlet {

    private static final int COLUMN_INDEX = 0;
    private static final int COLUMN_NAME = 1;
    private static final int COLUMN_DETAIL = 2;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int cId = Integer.parseInt(request.getParameter("cId"));
        String currentPageStr = request.getParameter("pageMedical");
        String sizeOfEachTableStr = request.getParameter("sizeMedical");

        int currentPage = (currentPageStr != null && !currentPageStr.isEmpty()) ? Integer.parseInt(currentPageStr) : 1;
        int sizeOfEachTable = (sizeOfEachTableStr != null && !sizeOfEachTableStr.isEmpty()) ? Integer.parseInt(sizeOfEachTableStr) : 10;

        CustomerDBContext customerDB = new CustomerDBContext();
        ArrayList<MedicalHistory> medicalHistory = customerDB.getMedicalHistoryByCustomerIdPaginated(cId, currentPage, sizeOfEachTable);

        try (Workbook workbook = new XSSFWorkbook()) {
            Sheet sheet = workbook.createSheet("Medical Histories");

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
            String[] headers = {"#", "Name", "Detail"};
            for (int i = 0; i < headers.length; i++) {
                Cell cell = headerRow.createCell(i);
                cell.setCellValue(headers[i]);
                cell.setCellStyle(headerStyle);
            }

            // Ghi dữ liệu
            int rowIndex = 1;
            for (MedicalHistory history : medicalHistory) {
                Row row = sheet.createRow(rowIndex++);
                Cell cellId = row.createCell(COLUMN_INDEX);
                cellId.setCellValue(rowIndex - 1);
                cellId.setCellStyle(dataStyle);

                Cell cellName = row.createCell(COLUMN_NAME);
                cellName.setCellValue(history.getName());
                cellName.setCellStyle(dataStyle);

                Cell cellDetail = row.createCell(COLUMN_DETAIL);
                cellDetail.setCellValue(history.getDetail());
                cellDetail.setCellStyle(dataStyle);
            }

            // Tự động điều chỉnh độ rộng cột
            for (int i = 0; i < 3; i++) {
                sheet.autoSizeColumn(i);
            }

            // Thiết lập HTTP response headers
            response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
            response.setHeader("Content-Disposition", "attachment; filename=medical_histories_page_" + currentPage + ".xlsx");

            // Ghi workbook vào output stream
            try (OutputStream out = response.getOutputStream()) {
                workbook.write(out);
            }
        }
    }
}
