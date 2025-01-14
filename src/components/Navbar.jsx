import React, { useState, useEffect } from "react";
import { useNavigate } from "react-router-dom";
import Login from "./Login";
import Register from "./Register";

const Navbar = () => {
    const [showLogin, setShowLogin] = useState(false);
    const [showRegister, setShowRegister] = useState(false);
    const [username, setUsername] = useState(null);
    const navigate = useNavigate();

    useEffect(() => {
        const storedUser = sessionStorage.getItem("user");
        if (storedUser) {
            setUsername(JSON.parse(storedUser).username);
        }
    }, []);

    const handleLoginClick = () => {
        setShowLogin(true);
        setShowRegister(false);
    };

    const handleRegisterClick = () => {
        setShowRegister(true);
        setShowLogin(false);
    };

    const handleChangeToRegister = () => {
        setShowLogin(false);
        setShowRegister(true);
    };

    const handleChangeToLogin = () => {
        setShowRegister(false);
        setShowLogin(true);
    };

    const handleLogout = () => {
        sessionStorage.removeItem("user");
        setUsername(null);
        navigate("/");
    };

    const handleLoginSuccess = (user) => {
        sessionStorage.setItem("user", JSON.stringify(user));
        setUsername(user.username);
    };

    const handleGoToProfile = () => {
        navigate("/profile");
    };

    return (
        <div className="container-fluid sticky-top bg-white shadow-sm mb-5">
            <div className="container">
                <nav className="navbar navbar-expand-lg bg-white navbar-light py-3 py-lg-0">
                    <a href="/" className="navbar-brand">
                        <h1 className="m-0 text-uppercase text-primary">
                            <i className="fa fa-clinic-medical me-2"></i>
                            Medinova
                        </h1>
                    </a>
                    <button
                        className="navbar-toggler"
                        type="button"
                        data-bs-toggle="collapse"
                        data-bs-target="#navbarCollapse"
                    >
                        <span className="navbar-toggler-icon"></span>
                    </button>
                    <div
                        className="collapse navbar-collapse"
                        id="navbarCollapse"
                    >
                        <div className="navbar-nav ms-auto py-0">
                            <a href="/" className="nav-item nav-link active">
                                Home
                            </a>
                            <a href="#!" className="nav-item nav-link">
                                About
                            </a>
                            <a href="#!" className="nav-item nav-link">
                                Service
                            </a>
                            <a href="price.html" className="nav-item nav-link">
                                Pricing
                            </a>
                            <div className="nav-item dropdown">
                                <a
                                    href="#!"
                                    className="nav-link dropdown-toggle"
                                    data-bs-toggle="dropdown"
                                >
                                    Pages
                                </a>
                                <div className="dropdown-menu m-0">
                                    <a href="#!" className="dropdown-item">
                                        Blog Grid
                                    </a>
                                    <a
                                        href="#!"
                                        className="dropdown-item active"
                                    >
                                        Blog Detail
                                    </a>
                                    <a href="#!" className="dropdown-item">
                                        The Team
                                    </a>
                                    <a href="#!" className="dropdown-item">
                                        Testimonial
                                    </a>
                                    <a href="#!" className="dropdown-item">
                                        Appointment
                                    </a>
                                    <a href="#!" className="dropdown-item">
                                        Search
                                    </a>
                                </div>
                            </div>
                            <a href="#!" className="nav-item nav-link">
                                Contact
                            </a>

                            {username ? (
                                <div className="nav-item nav-link">
                                    Hi, {username}
                                    <button
                                        className="btn btn-secondary ml-2"
                                        onClick={handleLogout}
                                        style={{ marginLeft: "10px" }}
                                    >
                                        Logout
                                    </button>
                                    {/* Khi nhấn vào username, chuyển hướng đến trang profile */}
                                    <button
                                        className="btn btn-secondary ml-2"
                                        onClick={handleGoToProfile}
                                    >
                                        Go to Profile
                                    </button>
                                </div>
                            ) : (
                                <>
                                    <button
                                        className="nav-item nav-link bg-primary btn-navbar"
                                        onClick={handleRegisterClick}
                                    >
                                        Register
                                    </button>
                                    <button
                                        className="nav-item nav-link bg-primary btn-navbar"
                                        onClick={handleLoginClick}
                                    >
                                        Login
                                    </button>
                                </>
                            )}
                        </div>
                    </div>
                </nav>
            </div>
            {showRegister && (
                <Register
                    onClose={() => setShowRegister(false)}
                    onSignInClick={handleChangeToLogin}
                />
            )}
            {showLogin && (
                <Login
                    onClose={() => setShowLogin(false)}
                    onSignUpClick={handleChangeToRegister}
                    onLoginSuccess={handleLoginSuccess}
                />
            )}
        </div>
    );
};

export default Navbar;
