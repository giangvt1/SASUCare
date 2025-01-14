import React, { useState, useEffect } from "react";
import { changePass } from "../services/api";

const Profile = () => {
    const [user, setUser] = useState({
        username: "",
        email: "",
    });

    const [currentPassword, setCurrentPassword] = useState("");
    const [newPassword, setNewPassword] = useState("");
    const [confirmPassword, setConfirmPassword] = useState("");
    const [passwordError, setPasswordError] = useState("");
    const [successMessage, setSuccessMessage] = useState("");

    useEffect(() => {
        const user = JSON.parse(sessionStorage.getItem("user"));
        const username = user.username;
        const email = user.email;
        if (username && email) {
            setUser({ username, email });
        }
    }, []);

    const handlePasswordChange = async (e) => {
        e.preventDefault();
        if (newPassword !== confirmPassword) {
            setPasswordError("New password and confirm password do not match.");
            return;
        }

        try {
            const result = await changePass(
                user.username,
                currentPassword,
                newPassword
            );
            setCurrentPassword("");
            setConfirmPassword("");
            setNewPassword("");
            setSuccessMessage("Password changed successfully.");

            console.log("Result:", result);
        } catch (error) {
            setPasswordError("Failed to change password. Please try again.");
            console.error("Error changing password:", error);
        }
    };

    return (
        <div className="container py-5">
            <div className="card shadow-lg p-4 mb-4">
                <h2 className="text-center mb-4">Profile</h2>
                <div className="row">
                    <div className="col-md-6">
                        <div className="mb-3">
                            <strong>Username:</strong>
                            <p className="form-control-plaintext">
                                {user.username}
                            </p>
                        </div>
                    </div>
                    <div className="col-md-6">
                        <div className="mb-3">
                            <strong>Email:</strong>
                            <p className="form-control-plaintext">
                                {user.email}
                            </p>
                        </div>
                    </div>
                </div>

                <h4 className="mt-4">Change Password</h4>

                <div className="mb-3">
                    <label htmlFor="currentPassword" className="form-label">
                        Current Password
                    </label>
                    <input
                        type="password"
                        id="currentPassword"
                        className="form-control"
                        value={currentPassword}
                        onChange={(e) => setCurrentPassword(e.target.value)}
                        placeholder="Enter current password"
                    />
                </div>

                <div className="mb-3">
                    <label htmlFor="newPassword" className="form-label">
                        New Password
                    </label>
                    <input
                        type="password"
                        id="newPassword"
                        className="form-control"
                        value={newPassword}
                        onChange={(e) => setNewPassword(e.target.value)}
                        placeholder="Enter new password"
                    />
                </div>

                <div className="mb-3">
                    <label htmlFor="confirmPassword" className="form-label">
                        Confirm New Password
                    </label>
                    <input
                        type="password"
                        id="confirmPassword"
                        className="form-control"
                        value={confirmPassword}
                        onChange={(e) => setConfirmPassword(e.target.value)}
                        placeholder="Confirm new password"
                    />
                </div>

                {passwordError && (
                    <p className="text-danger">{passwordError}</p>
                )}
                {successMessage && (
                    <p className="text-success">{successMessage}</p>
                )}

                <div className="text-center">
                    <button
                        className="btn btn-primary"
                        onClick={handlePasswordChange}
                    >
                        Update Password
                    </button>
                </div>
            </div>
        </div>
    );
};

export default Profile;
