package Model;

public class Account {
    private String username;
    private String password;
    private String D_name;

    public Account(String username, String password, String d_name) {
        this.username = username;
        this.password = password;
        D_name = d_name;
    }

    public Account() {
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getD_name() {
        return D_name;
    }

    public void setD_name(String d_name) {
        D_name = d_name;
    }
}
