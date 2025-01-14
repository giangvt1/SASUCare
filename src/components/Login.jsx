import React, { useState } from "react";
import { authenticateUser } from "../services/api";
import { useNavigate } from "react-router-dom";

const Login = ({ onClose, onSignUpClick }) => {
    const [username, setUsername] = useState("");
    const [password, setPassword] = useState("");
    const [errorMessage, setErrorMessage] = useState("");
    const navigate = useNavigate();

    const handleSubmit = async (e) => {
        e.preventDefault();

        try {
            const result = await authenticateUser(username, password);
            alert("Login successful!");

            const userData = result.data.result;

            console.log("User data:", userData);
            sessionStorage.setItem("user", JSON.stringify(userData));

            onClose();
            window.location.reload();
            navigate("/home");
        } catch (error) {
            setErrorMessage(
                "An error occurred during login. Please try again later."
            );
            setUsername("");
            setPassword("");
            console.error("Login error:", error);
        }
    };

    return (
        <div className="login-container">
            <div className="d-flex justify-content-center bg-white login">
                <form onSubmit={handleSubmit}>
                    <div className="close position-absolute" onClick={onClose}>
                        ×
                    </div>
                    <h3 className="text-center mt-4">Log in</h3>
                    <span className="d-flex justify-content-center">
                        Don't have an account?{" "}
                        <a
                            href="#"
                            onClick={(e) => {
                                e.preventDefault();
                                onSignUpClick();
                            }}
                        >
                            &nbsp;Sign up
                        </a>
                    </span>
                    {errorMessage && (
                        <div className="alert alert-danger mt-3" role="alert">
                            {errorMessage}
                        </div>
                    )}
                    <table className="mt-4 mb-4">
                        <tbody>
                            <tr>
                                <td>
                                    <b>Username</b>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <input
                                        className="input"
                                        type="text"
                                        name="username"
                                        placeholder="Enter username"
                                        value={username}
                                        onChange={(e) =>
                                            setUsername(e.target.value)
                                        }
                                    />
                                </td>
                            </tr>
                            <tr>
                                <td className="pt-4">
                                    <b>Password</b>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <input
                                        className="input"
                                        type="password"
                                        name="password"
                                        placeholder="Enter password"
                                        value={password}
                                        onChange={(e) =>
                                            setPassword(e.target.value)
                                        }
                                    />
                                </td>
                            </tr>
                            <tr>
                                <td className="text-end pt-2">
                                    <a
                                        href="#"
                                        onClick={(e) => e.preventDefault()}
                                    >
                                        Forgot Password
                                    </a>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <button
                                        className="button mt-4"
                                        type="submit"
                                    >
                                        Login
                                    </button>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </form>
            </div>
        </div>
    );
};

export default Login;
