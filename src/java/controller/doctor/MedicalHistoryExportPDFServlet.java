package controller.doctor;

import dao.CustomerDBContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.MedicalHistory;
import com.itextpdf.text.Document;
import com.itextpdf.text.DocumentException;
import com.itextpdf.text.Element;
import com.itextpdf.text.Font;
import com.itextpdf.text.Paragraph;
import com.itextpdf.text.Phrase;
import com.itextpdf.text.pdf.PdfPCell;
import com.itextpdf.text.pdf.PdfPTable;
import com.itextpdf.text.pdf.PdfWriter;
import java.io.IOException;
import java.util.ArrayList;

public class MedicalHistoryExportPDFServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int cId = Integer.parseInt(request.getParameter("cId"));
        String currentPageStr = request.getParameter("pageMedical");
        String sizeOfEachTableStr = request.getParameter("sizeMedical");

        int currentPage = (currentPageStr != null && !currentPageStr.isEmpty()) ? Integer.parseInt(currentPageStr) : 1;
        int sizeOfEachTable = (sizeOfEachTableStr != null && !sizeOfEachTableStr.isEmpty()) ? Integer.parseInt(sizeOfEachTableStr) : 10;

        CustomerDBContext customerDB = new CustomerDBContext();
        ArrayList<MedicalHistory> medicalHistory = customerDB.getMedicalHistoryByCustomerIdPaginated(cId, currentPage, sizeOfEachTable);

        response.setContentType("application/pdf");
        response.setHeader("Content-Disposition", "attachment; filename=medical_histories_page_" + currentPage + ".pdf");

        try {
            Document document = new Document();
            PdfWriter.getInstance(document, response.getOutputStream());
            document.open();

            // Tiêu đề
            Font titleFont = new Font(Font.FontFamily.HELVETICA, 16, Font.BOLD);
            Paragraph title = new Paragraph("Medical Histories", titleFont);
            title.setAlignment(Element.ALIGN_CENTER);
            document.add(title);
            document.add(new Paragraph("\n"));
            // Tạo bảng
            PdfPTable table = new PdfPTable(3);
            table.setWidthPercentage(100);
            table.setWidths(new float[]{1, 3, 6});

            Font headerFont = new Font(Font.FontFamily.HELVETICA, 12, Font.BOLD);
            table.addCell(new PdfPCell(new Phrase("#", headerFont)));
            table.addCell(new PdfPCell(new Phrase("Name", headerFont)));
            table.addCell(new PdfPCell(new Phrase("Detail", headerFont)));

            int index = 1;
            for (MedicalHistory history : medicalHistory) {
                table.addCell(String.valueOf(index++));
                table.addCell(history.getName());
                table.addCell(history.getDetail());
            }

            document.add(table);
            document.close();
        } catch (DocumentException de) {
            throw new IOException(de.getMessage());
        }
    }
}
