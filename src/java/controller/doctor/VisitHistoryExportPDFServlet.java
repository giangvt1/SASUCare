package controller.doctor;

import dao.CustomerDBContext;
import model.VisitHistory;
import com.itextpdf.text.Document;
import com.itextpdf.text.DocumentException;
import com.itextpdf.text.Element;
import com.itextpdf.text.Font;
import com.itextpdf.text.Paragraph;
import com.itextpdf.text.Phrase;
import com.itextpdf.text.pdf.BaseFont;
import com.itextpdf.text.pdf.PdfPCell;
import com.itextpdf.text.pdf.PdfPTable;
import com.itextpdf.text.pdf.PdfWriter;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class VisitHistoryExportPDFServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Lấy các tham số từ request
        int cId = Integer.parseInt(request.getParameter("cId"));
        String currentPageStr = request.getParameter("pageVisit");
        String sizeOfEachTableStr = request.getParameter("sizevisit");

        // Xử lý các tham số phân trang
        int currentPage = (currentPageStr != null && !currentPageStr.isEmpty()) ? Integer.parseInt(currentPageStr) : 1;
        int sizeOfEachTable = (sizeOfEachTableStr != null && !sizeOfEachTableStr.isEmpty()) ? Integer.parseInt(sizeOfEachTableStr) : 10;

        // Lấy dữ liệu từ cơ sở dữ liệu
        CustomerDBContext customerDB = new CustomerDBContext();
        ArrayList<VisitHistory> visitHistory = customerDB.getVisitHistoriesByCustomerIdPaginated(cId, currentPage, sizeOfEachTable);

        // Thiết lập response để tải file PDF
        response.setContentType("application/pdf");
        response.setHeader("Content-Disposition", "attachment; filename=visit_histories_page_" + currentPage + ".pdf");

        try {
            Document document = new Document();
            PdfWriter.getInstance(document, response.getOutputStream());
            document.open();
            String fontPath = getServletContext().getRealPath("/fonts/vuArial.ttf");
            BaseFont baseFont = BaseFont.createFont(fontPath, BaseFont.IDENTITY_H, BaseFont.EMBEDDED);

            String fontPath = getServletContext().getRealPath("/fonts/vuArial.ttf");
            BaseFont baseFont = BaseFont.createFont(fontPath, BaseFont.IDENTITY_H, BaseFont.EMBEDDED);
            Font titleFont = new Font(baseFont, 16, Font.BOLD);
            Font headerFont = new Font(baseFont, 12, Font.BOLD);
            Font contentFont = new Font(baseFont, 10, Font.NORMAL);

            Paragraph title = new Paragraph("Visit Histories", titleFont);
            title.setAlignment(Element.ALIGN_CENTER);
            document.add(title);
            document.add(new Paragraph("\n"));

            PdfPTable table = new PdfPTable(6);
            table.setWidthPercentage(100);
            table.setWidths(new float[]{1, 2, 2, 2, 2, 2});

            // Font cho tiêu đề các cột
            table.addCell(new PdfPCell(new Phrase("#", headerFont)));
            table.addCell(new PdfPCell(new Phrase("Visit Date", headerFont)));
            table.addCell(new PdfPCell(new Phrase("Reason For Visit", headerFont)));
            table.addCell(new PdfPCell(new Phrase("Diagnoses", headerFont)));
            table.addCell(new PdfPCell(new Phrase("Treatment Plan", headerFont)));
            table.addCell(new PdfPCell(new Phrase("Next Appointment", headerFont)));

            // Định dạng ngày tháng
            SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");

            int index = 1;
            for (VisitHistory history : visitHistory) {
                table.addCell(String.valueOf(index++));
                // Kiểm tra và định dạng ngày tháng

                table.addCell(new PdfPCell(new Phrase(String.valueOf(index++), contentFont)));
                table.addCell(new PdfPCell(new Phrase(history.getVisitDate() != null ? dateFormat.format(history.getVisitDate()) : "Invalid Date", contentFont)));
                table.addCell(new PdfPCell(new Phrase(history.getReasonForVisit() != null ? history.getReasonForVisit() : "", contentFont)));
                table.addCell(new PdfPCell(new Phrase(history.getDiagnoses() != null ? history.getDiagnoses() : "", contentFont)));
                table.addCell(new PdfPCell(new Phrase(history.getTreatmentPlan() != null ? history.getTreatmentPlan() : "", contentFont)));
                table.addCell(new PdfPCell(new Phrase(history.getNextAppointment() != null ? dateFormat.format(history.getNextAppointment()) : "No Appointment", contentFont)));

            }

            // Thêm bảng vào tài liệu PDF
            document.add(table);
            document.close();
        } catch (DocumentException de) {
            // Nếu có lỗi trong quá trình tạo PDF, ném lỗi vào response
            throw new IOException(de.getMessage());
        }
    }
}
