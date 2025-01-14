import axios from "axios";

const apiClient = axios.create({
    baseURL: "http://localhost:8080",
    timeout: 10000,
});

export const authenticateUser = async (username, password) => {
    const result = await apiClient.post("/identity/users/login", {
        username,
        password,
    });
    return result;
};

export const createUser = async (username, password, email) => {
    const result = await apiClient.post("/identity/users/register", {
        username,
        password,
        email,
    });
    return result;
};

export const changePass = async (username, currentPassword, newPassword) => {
    const result = await apiClient.post("/identity/users/changePassword", {
        username,
        currentPassword,
        newPassword,
    });

    return result;
};

export default apiClient;
