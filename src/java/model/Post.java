package model;

import java.sql.Timestamp;

public class Post {

    private int id;
    private String title;
    private String content;
    private Timestamp createdAt;
    private Timestamp updatedAt;
    private boolean status;
    private int staffId;
    private String staffName;
    private String image;
    private String detail;

    public Post() {
    }

    // Constructor với full tham số (kể cả staffName)
    public Post(int id, String title, String content, Timestamp createdAt, Timestamp updatedAt, boolean status, int staffId, String staffName) {
        this.id = id;
        this.title = title;
        this.content = content;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
        this.status = status;
        this.staffId = staffId;
        this.staffName = staffName;
    }

    // Constructor chỉ cần các tham số cần thiết (không có staffName)
    public Post(int id, String title, String content, Timestamp createdAt, Timestamp updatedAt, boolean status, int staffId) {
        this.id = id;
        this.title = title;
        this.content = content;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
        this.status = status;
        this.staffId = staffId;
    }

    public Post(String title, String content, int staffId, String image) {
        this.title = title;
        this.content = content;
        this.staffId = staffId;
        this.image = image;
    }

    public Post(int id, String title, String content, int staffId, String image, boolean status) {
        this.id = id;
        this.title = title;
        this.content = content;
        this.staffId = staffId;
        this.image = image;
        this.status = status;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public Timestamp getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(Timestamp updatedAt) {
        this.updatedAt = updatedAt;
    }

    public boolean isStatus() {
        return status;
    }

    public void setStatus(boolean status) {
        this.status = status;
    }

    public int getStaffId() {
        return staffId;
    }

    public void setStaffId(int staffId) {
        this.staffId = staffId;
    }

    public String getStaffName() {
        return staffName;
    }

    public void setStaffName(String staffName) {
        this.staffName = staffName;
    }

    public String getImage() {
        return image;
    }

    public void setImage(String image) {
        this.image = image;
    }

    public String getDetail() {
        return detail;
    }

    public void setDetail(String detail) {
        this.detail = detail;
    }

    // Phương thức toString() để dễ dàng kiểm tra
    @Override
    public String toString() {
        return "Post{"
                + "id=" + id
                + ", title='" + title + '\''
                + ", content='" + content + '\''
                + ", createdAt=" + createdAt
                + ", updatedAt=" + updatedAt
                + ", status=" + status
                + ", staffId=" + staffId
                + ", staffName='" + staffName + '\''
                + '}';
    }
}
