/*
 * Updated GoogleDBContext class with OTP expiry and 3-minute waiting period for resending.
 */
package dao;

import dal.DBContext;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.Properties;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.GoogleAccount;
import jakarta.mail.Authenticator;
import jakarta.mail.PasswordAuthentication;
import jakarta.mail.Session;
import jakarta.mail.Transport;
import jakarta.mail.Message;
import jakarta.mail.MessagingException;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;
import java.security.SecureRandom;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

public class GoogleDBContext extends DBContext<GoogleAccount> {

    private static final Logger LOGGER = Logger.getLogger(GoogleDBContext.class.getName());
    private static final long WAIT_TIME_MS = 180_000;
    private static final Map<String, Long> lastMailSentTime = new ConcurrentHashMap<>();
    private static final Map<String, OTPDetails> otpStorage = new ConcurrentHashMap<>();

    // Helper class to store OTP details
    public static class OTPDetails {

        private final String otp;
        private final long generatedTime;

        public OTPDetails(String otp, long generatedTime) {
            this.otp = otp;
            this.generatedTime = generatedTime;
        }

        public String getOtp() {
            return otp;
        }

        public long getGeneratedTime() {
            return generatedTime;
        }
    }

    public GoogleAccount findByEmail(String email) {
        String sql = "SELECT * FROM [Google_Authen] WHERE email = ?";
        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setString(1, email);
            ResultSet rs = stm.executeQuery();
            if (rs.next()) {
                GoogleAccount account = new GoogleAccount();
                account.setId(rs.getString("account_id")); // Lấy account_id
                account.setEmail(rs.getString("email")); // Lấy email
                account.setName(rs.getString("name")); // Lấy name
                account.setFirst_name(rs.getString("first_name")); // Lấy first_name
                account.setGiven_name(rs.getString("given_name")); // Lấy given_name
                account.setFamily_name(rs.getString("family_name")); // Lấy family_name
                account.setPicture(rs.getString("picture")); // Lấy picture
                account.setVerified_email(rs.getBoolean("verified_email")); // Lấy verified_email
                return account;
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error finding user by email: {0}", ex.getMessage());
        }
        return null;
    }

    public boolean isGoogleExist(String email) {
        String sql = "SELECT * FROM [Google_Authen] WHERE email = ?";
        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setString(1, email);
            ResultSet rs = stm.executeQuery();
            if (rs.next()) {
                return true;
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error finding user by email: {0}", ex.getMessage());
        }
        return false;
    }

    @Override
    public void insert(GoogleAccount model) {
        String sql = """
            INSERT INTO [Google_Authen] (account_id, email, name, first_name, given_name, family_name, picture, verified_email) 
            VALUES (?, ?, ?, ?, ?, ?, ?, ?)
        """;
        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setString(1, model.getId());
            stm.setString(2, model.getEmail());
            stm.setString(3, model.getName());
            stm.setString(4, model.getFirst_name());
            stm.setString(5, model.getGiven_name());
            stm.setString(6, model.getFamily_name());
            stm.setString(7, model.getPicture());
            stm.setBoolean(8, model.isVerified_email());

            int rowsAffected = stm.executeUpdate();
            if (rowsAffected > 0) {
                System.out.println("GoogleAccount inserted successfully.");
            } else {
                System.out.println("GoogleAccount insert failed.");
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error inserting GoogleAccount: {0}", ex.getMessage());
        }
    }

    @Override
    public void update(GoogleAccount model) {
        String sql = """
            UPDATE [Google_Authen] 
            SET email = ?, name = ?, first_name = ?, given_name = ?, family_name = ?, picture = ?, verified_email = ?
            WHERE account_id = ?
        """;
        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setString(1, model.getEmail());
            stm.setString(2, model.getName());
            stm.setString(3, model.getFirst_name());
            stm.setString(4, model.getGiven_name());
            stm.setString(5, model.getFamily_name());
            stm.setString(6, model.getPicture());
            stm.setBoolean(7, model.isVerified_email());
            stm.setString(8, model.getId());

            int rowsAffected = stm.executeUpdate();
            if (rowsAffected > 0) {
                System.out.println("GoogleAccount updated successfully.");
            } else {
                System.out.println("No GoogleAccount found with the given account_id.");
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error updating GoogleAccount: {0}", ex.getMessage());
        }
    }

    @Override
    public void delete(GoogleAccount model) {
        String sql = "DELETE FROM [Google_Authen] WHERE account_id = ?";
        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setString(1, model.getId());
            int rowsAffected = stm.executeUpdate();
            if (rowsAffected > 0) {
                System.out.println("GoogleAccount deleted successfully.");
            } else {
                System.out.println("No GoogleAccount found with the given account_id.");
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error deleting GoogleAccount: {0}", ex.getMessage());
        }
    }

    @Override
    public ArrayList<GoogleAccount> list() {
        ArrayList<GoogleAccount> ggAccounts = new ArrayList<>();
        String sql = "SELECT * FROM [Google_Authen]";
        try (Statement stm = connection.createStatement(); ResultSet rs = stm.executeQuery(sql)) {
            while (rs.next()) {
                GoogleAccount account = new GoogleAccount();
                account.setId(rs.getString("account_id"));
                account.setEmail(rs.getString("email"));
                account.setName(rs.getString("name"));
                account.setFirst_name(rs.getString("first_name"));
                account.setGiven_name(rs.getString("given_name"));
                account.setFamily_name(rs.getString("family_name"));
                account.setPicture(rs.getString("picture"));
                account.setVerified_email(rs.getBoolean("verified_email"));
                ggAccounts.add(account);
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error listing GoogleAccounts: {0}", ex.getMessage());
        }
        return ggAccounts;
    }

    @Override
    public GoogleAccount get(String account_id) {
        GoogleAccount account = null;
        String sql = "SELECT * FROM [Google_Authen] WHERE account_id = ?";
        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setString(1, account_id);
            ResultSet rs = stm.executeQuery();
            if (rs.next()) {
                account = new GoogleAccount();
                account.setId(rs.getString("account_id"));
                account.setEmail(rs.getString("email"));
                account.setName(rs.getString("name"));
                account.setFirst_name(rs.getString("first_name"));
                account.setGiven_name(rs.getString("given_name"));
                account.setFamily_name(rs.getString("family_name"));
                account.setPicture(rs.getString("picture"));
                account.setVerified_email(rs.getBoolean("verified_email"));
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error fetching GoogleAccount data: {0}", ex.getMessage());
        }
        return account;
    }

    public int sendOtp(String gmail) {
        SecureRandom secureRandom = new SecureRandom();
        int otpValue = 100000 + secureRandom.nextInt(900000);
        String otpStr = String.valueOf(otpValue);
        String otpMessage = "Your OTP: " + otpStr;
        if (sendMail(gmail, "OTP", otpMessage)) {
            // Store OTP with the current timestamp for validation
            otpStorage.put(gmail, new OTPDetails(otpStr, System.currentTimeMillis()));
            return otpValue;
        }
        return -1;
    }

    public boolean sendMail(String gmail, String title, String messageContent) {
        long currentTime = System.currentTimeMillis();
        Long lastSentTime = lastMailSentTime.get(gmail);
        if (lastSentTime != null && (currentTime - lastSentTime) < WAIT_TIME_MS) {
            System.err.println("Please wait at least 3 minutes before requesting another mail.");
            return false;
        }
        Properties props = new Properties();
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.socketFactory.port", "465");
        props.put("mail.smtp.socketFactory.class", "javax.net.ssl.SSLSocketFactory");
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.port", "465");

        // Choose credentials based on title or context if needed.
        // Here, for OTP, we use one account; for password, another could be used.
        Session session = Session.getInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                // For demonstration, using a fixed credential.
                return new PasswordAuthentication("hailnhe181075@fpt.edu.vn", "mjpxokkwmtgkxqro");
            }
        });

        try {
            MimeMessage message = new MimeMessage(session);
            message.setFrom(new InternetAddress("hailnhe181075@fpt.edu.vn"));
            message.setRecipients(Message.RecipientType.TO, gmail);
            message.setSubject(title, "UTF-8");
            message.setText(messageContent, "UTF-8");

            Transport.send(message);
            System.out.println("Message sent successfully to " + gmail);
            // Update last mail sent timestamp
            lastMailSentTime.put(gmail, currentTime);
            return true;
        } catch (MessagingException e) {
            LOGGER.log(Level.SEVERE, "Error sending mail", e);
            e.printStackTrace();
            return false;
        }
    }

    // Send password by email with rate limiting (3 minutes wait)
    public boolean sendPasswordByEmail(String recipientEmail, String password) {
        if (recipientEmail == null || recipientEmail.trim().isEmpty()) {
            System.err.println("Recipient email is null or empty.");
            return false;
        }
        long currentTime = System.currentTimeMillis();
        Long lastSentTime = lastMailSentTime.get(recipientEmail);
        if (lastSentTime != null && (currentTime - lastSentTime) < WAIT_TIME_MS) {
            System.err.println("Please wait at least 3 minutes before requesting another mail.");
            return false;
        }

        Properties props = new Properties();
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.socketFactory.port", "465");
        props.put("mail.smtp.socketFactory.class", "javax.net.ssl.SSLSocketFactory");
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.port", "465");

        Session session = Session.getInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication("giangvthe187264@fpt.edu.vn", "dgoalidwbptuooya");
            }
        });
        session.setDebug(true);

        try {
            MimeMessage mimeMessage = new MimeMessage(session);
            mimeMessage.setFrom(new InternetAddress("giangvthe187264@fpt.edu.vn"));
            mimeMessage.setRecipients(Message.RecipientType.TO, InternetAddress.parse(recipientEmail));
            mimeMessage.setSubject("Your New Account Password");
            mimeMessage.setText("Dear User,\n\nYour new account has been created. Your password is: "
                    + password
                    + "\n\nPlease change your password after logging in.\n\nBest regards,\nAdmin: Vu Truong Giang", "UTF-8");

            Transport.send(mimeMessage);
            System.out.println("Password email sent successfully to " + recipientEmail);
            lastMailSentTime.put(recipientEmail, currentTime);
            return true;
        } catch (MessagingException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Send OTP by email with rate limiting (3 minutes wait)
    public boolean sendOTPByEmail(String recipientEmail, String OTP) {
        if (recipientEmail == null || recipientEmail.trim().isEmpty()) {
            System.err.println("Recipient email is null or empty.");
            return false;
        }
        if (sendMail(recipientEmail, "Forget password", "Dear User, you're requesting an OTP to reset your password. Here is your OTP: "
                + OTP
                + "\n\nThank you for using our services.\n\nBest regards,\nAdmin: Vu Truong Giang")) {
            return true;
        } else {
            return false;
        }
    }

    // Validate the OTP provided by the customer.
    // Returns true if OTP is valid and within 3 minutes; false otherwise.
    public boolean verifyOtp(String gmail, String providedOtp) {
        OTPDetails details = otpStorage.get(gmail);
        if (details == null) {
            System.out.println("No OTP was sent to this email.");
            return false;
        }
        long currentTime = System.currentTimeMillis();
        if ((currentTime - details.getGeneratedTime()) > WAIT_TIME_MS) { // OTP expired after 3 minutes
            System.out.println("OTP expired. Please request a new OTP.");
            otpStorage.remove(gmail);
            return false;
        }
        if (details.getOtp().equals(providedOtp)) {
            System.out.println("OTP verified successfully.");
            otpStorage.remove(gmail);
            return true;
        } else {
            System.out.println("Invalid OTP provided.");
            return false;
        }
    }

    public String generateRandomPassword(int length) {
        SecureRandom secureRandom = new SecureRandom();
        String chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!@#$%^&*";
        StringBuilder sb = new StringBuilder();
        for (int i = 0; i < length; i++) {
            int randomIndex = secureRandom.nextInt(chars.length());
            sb.append(chars.charAt(randomIndex));
        }
        return sb.toString();
    }
}
