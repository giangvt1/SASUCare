import React, { useState } from "react";
import { createUser } from "../services/api";
import { useNavigate } from "react-router-dom";

function Register({ onClose, onSignInClick }) {
    const [username, setUsername] = useState("");
    const [password, setPassword] = useState("");
    const [confirmPassword, setConfirmPassword] = useState("");
    const [email, setEmail] = useState("");
    const [errorMessage, setErrorMessage] = useState("");

    const navigate = useNavigate();

    const handleSubmit = async (e) => {
        e.preventDefault();

        if (!username || !password || !confirmPassword || !email) {
            setErrorMessage("All fields are required.");
            return;
        }

        if (password !== confirmPassword) {
            setErrorMessage("Password and Confirm Password do not match!");
            return;
        }

        console.log("Form submitted:", { username, password, email });

        try {
            await createUser(username, password, email);
            alert("Registration successful!");
            onClose();
            onSignInClick();
        } catch (error) {
            setErrorMessage(
                error.response?.data?.message ||
                    "An error occurred during registration. Please try again later."
            );
        }
    };

    return (
        <div className="container d-flex justify-content-center bg-white">
            <form onSubmit={handleSubmit}>
                <div className="close position-absolute" onClick={onClose}>
                    ×
                </div>
                <h3 className="text-center mt-4">Register</h3>
                <span className="d-flex justify-content-center">
                    Already have an account?{" "}
                    <a
                        href="#"
                        onClick={(e) => {
                            e.preventDefault();
                            onClose();
                            onSignInClick();
                        }}
                    >
                        &nbsp;Login
                    </a>
                </span>
                {errorMessage && (
                    <div
                        className="alert alert-danger mt-3 text-center"
                        role="alert"
                    >
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
                                <b>Email</b>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <input
                                    className="input"
                                    type="email"
                                    name="email"
                                    placeholder="Enter email"
                                    value={email}
                                    onChange={(e) => setEmail(e.target.value)}
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
                            <td className="pt-4">
                                <b>Confirm Password</b>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <input
                                    className="input"
                                    type="password"
                                    name="confirm-password"
                                    placeholder="Confirm password"
                                    value={confirmPassword}
                                    onChange={(e) =>
                                        setConfirmPassword(e.target.value)
                                    }
                                />
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <button className="button mt-4" type="submit">
                                    Register
                                </button>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </form>
        </div>
    );
}

export default Register;
