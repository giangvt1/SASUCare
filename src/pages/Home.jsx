import React from "react";

const Home = () => {
    return (
        <>
            {/* Hero Start */}
            <div className="container-fluid bg-primary py-5 mb-5 hero-header">
                <div className="container py-5">
                    <div className="row justify-content-start">
                        <div className="col-lg-8 text-center text-lg-start">
                            <h5
                                className="d-inline-block text-primary text-uppercase border-bottom border-5"
                                style={{
                                    borderColor: "rgba(256, 256, 256, 0.3)",
                                }}
                            >
                                Welcome To Medinova
                            </h5>
                            <h1 className="display-1 text-white mb-md-4">
                                Best Healthcare Solution In Your City
                            </h1>
                            <div className="pt-2">
                                <a
                                    href="/"
                                    className="btn btn-light rounded-pill py-md-3 px-md-5 mx-2"
                                >
                                    Find Doctor
                                </a>
                                <a
                                    href="/"
                                    className="btn btn-outline-light rounded-pill py-md-3 px-md-5 mx-2"
                                >
                                    Appointment
                                </a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            {/* Hero End */}

            {/* About Start */}
            <div className="container-fluid py-5">
                <div className="container">
                    <div className="row gx-5">
                        <div
                            className="col-lg-5 mb-5 mb-lg-0"
                            style={{ minHeight: "500px" }}
                        >
                            <div className="position-relative h-100">
                                <img
                                    className="position-absolute w-100 h-100 rounded"
                                    src="img/about.jpg"
                                    alt="About Us"
                                    style={{ objectFit: "cover" }}
                                />
                            </div>
                        </div>
                        <div className="col-lg-7">
                            <div className="mb-4">
                                <h5 className="d-inline-block text-primary text-uppercase border-bottom border-5">
                                    About Us
                                </h5>
                                <h1 className="display-4">
                                    Best Medical Care For Yourself and Your
                                    Family
                                </h1>
                            </div>
                            <p>
                                Tempor erat elitr at rebum at at clita aliquyam
                                consetetur. Diam dolor diam ipsum et, tempor
                                voluptua sit consetetur sit. Aliquyam diam amet
                                diam et eos sadipscing labore. Clita erat ipsum
                                et lorem et sit, sed stet no labore lorem sit.
                                Sanctus clita duo justo et tempor consetetur
                                takimata eirmod, dolores takimata consetetur
                                invidunt magna dolores aliquyam dolores dolore.
                                Amet erat amet et magna
                            </p>
                            <div className="row g-3 pt-3">
                                {[
                                    {
                                        icon: "fa-user-md",
                                        text: "Qualified Doctors",
                                    },
                                    {
                                        icon: "fa-procedures",
                                        text: "Emergency Services",
                                    },
                                    {
                                        icon: "fa-microscope",
                                        text: "Accurate Testing",
                                    },
                                    {
                                        icon: "fa-ambulance",
                                        text: "Free Ambulance",
                                    },
                                ].map((item, index) => (
                                    <div className="col-sm-3 col-6" key={index}>
                                        <div className="bg-light text-center rounded-circle py-4">
                                            <i
                                                className={`fa fa-3x ${item.icon} text-primary mb-3`}
                                            ></i>
                                            <h6 className="mb-0">
                                                {item.text.split(" ")[0]}
                                                <small className="d-block text-primary">
                                                    {item.text.split(" ")[1]}
                                                </small>
                                            </h6>
                                        </div>
                                    </div>
                                ))}
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            {/* About End */}

            {/* Services Start */}
            <div className="container-fluid py-5">
                <div className="container">
                    <div
                        className="text-center mx-auto mb-5"
                        style={{ maxWidth: "500px" }}
                    >
                        <h5 className="d-inline-block text-primary text-uppercase border-bottom border-5">
                            Services
                        </h5>
                        <h1 className="display-4">
                            Excellent Medical Services
                        </h1>
                    </div>
                    <div className="row g-5">
                        {[
                            {
                                icon: "fa-user-md",
                                title: "Emergency Care",
                                desc: "Kasd dolor no lorem nonumy sit labore tempor at justo rebum rebum stet, justo elitr dolor amet sit",
                            },
                            {
                                icon: "fa-procedures",
                                title: "Operation & Surgery",
                                desc: "Kasd dolor no lorem nonumy sit labore tempor at justo rebum rebum stet, justo elitr dolor amet sit",
                            },
                            {
                                icon: "fa-stethoscope",
                                title: "Outdoor Checkup",
                                desc: "Kasd dolor no lorem nonumy sit labore tempor at justo rebum rebum stet, justo elitr dolor amet sit",
                            },
                            {
                                icon: "fa-ambulance",
                                title: "Ambulance Service",
                                desc: "Kasd dolor no lorem nonumy sit labore tempor at justo rebum rebum stet, justo elitr dolor amet sit",
                            },
                            {
                                icon: "fa-pills",
                                title: "Medicine & Pharmacy",
                                desc: "Kasd dolor no lorem nonumy sit labore tempor at justo rebum rebum stet, justo elitr dolor amet sit",
                            },
                            {
                                icon: "fa-microscope",
                                title: "Blood Testing",
                                desc: "Kasd dolor no lorem nonumy sit labore tempor at justo rebum rebum stet, justo elitr dolor amet sit",
                            },
                        ].map((service, index) => (
                            <div className="col-lg-4 col-md-6" key={index}>
                                <div className="service-item bg-light rounded d-flex flex-column align-items-center justify-content-center text-center">
                                    <div className="service-icon mb-4">
                                        <i
                                            className={`fa fa-2x ${service.icon} text-white`}
                                        ></i>
                                    </div>
                                    <h4 className="mb-3">{service.title}</h4>
                                    <p className="m-0">{service.desc}</p>
                                    <a
                                        className="btn btn-lg btn-primary rounded-pill"
                                        href="/"
                                    >
                                        <i className="bi bi-arrow-right"></i>
                                    </a>
                                </div>
                            </div>
                        ))}
                    </div>
                </div>
            </div>
            {/* Services End */}
            {/* Appointment Start */}
            <div className="container-fluid bg-primary my-5 py-5">
                <div className="container py-5">
                    <div className="row gx-5">
                        <div className="col-lg-6 mb-5 mb-lg-0">
                            <div className="mb-4">
                                <h5 className="d-inline-block text-white text-uppercase border-bottom border-5">
                                    Appointment
                                </h5>
                                <h1 className="display-4">
                                    Make An Appointment For Your Family
                                </h1>
                            </div>
                            <p className="text-white mb-5">
                                Eirmod sed tempor lorem ut dolores. Aliquyam sit
                                sadipscing kasd ipsum. Dolor ea et dolore et at
                                sea ea at dolor, justo ipsum duo rebum sea
                                invidunt voluptua. Eos vero eos vero ea et
                                dolore eirmod et. Dolores diam duo invidunt
                                lorem. Elitr ut dolores magna sit. Sea dolore
                                sanctus sed et. Takimata takimata sanctus sed.
                            </p>
                            <a
                                className="btn btn-dark rounded-pill py-3 px-5 me-3"
                                href=""
                            >
                                Find Doctor
                            </a>
                            <a
                                className="btn btn-outline-dark rounded-pill py-3 px-5"
                                href=""
                            >
                                Read More
                            </a>
                        </div>
                        <div className="col-lg-6">
                            <div className="bg-white text-center rounded p-5">
                                <h1 className="mb-4">Book An Appointment</h1>
                                <form>
                                    <div className="row g-3">
                                        <div className="col-12 col-sm-6">
                                            <select
                                                className="form-select bg-light border-0"
                                                style={{ height: "55px" }}
                                            >
                                                <option defaultValue>
                                                    Choose Department
                                                </option>
                                                <option value="1">
                                                    Department 1
                                                </option>
                                                <option value="2">
                                                    Department 2
                                                </option>
                                                <option value="3">
                                                    Department 3
                                                </option>
                                            </select>
                                        </div>
                                        <div className="col-12 col-sm-6">
                                            <select
                                                className="form-select bg-light border-0"
                                                style={{ height: "55px" }}
                                            >
                                                <option defaultValue>
                                                    Select Doctor
                                                </option>
                                                <option value="1">
                                                    Doctor 1
                                                </option>
                                                <option value="2">
                                                    Doctor 2
                                                </option>
                                                <option value="3">
                                                    Doctor 3
                                                </option>
                                            </select>
                                        </div>
                                        <div className="col-12 col-sm-6">
                                            <input
                                                type="text"
                                                className="form-control bg-light border-0"
                                                placeholder="Your Name"
                                                style={{ height: "55px" }}
                                            />
                                        </div>
                                        <div className="col-12 col-sm-6">
                                            <input
                                                type="email"
                                                className="form-control bg-light border-0"
                                                placeholder="Your Email"
                                                style={{ height: "55px" }}
                                            />
                                        </div>
                                        <div className="col-12 col-sm-6">
                                            <div
                                                className="date"
                                                data-target-input="nearest"
                                            >
                                                <input
                                                    type="text"
                                                    className="form-control bg-light border-0 datetimepicker-input"
                                                    placeholder="Date"
                                                    style={{ height: "55px" }}
                                                />
                                            </div>
                                        </div>
                                        <div className="col-12 col-sm-6">
                                            <div
                                                className="time"
                                                data-target-input="nearest"
                                            >
                                                <input
                                                    type="text"
                                                    className="form-control bg-light border-0 datetimepicker-input"
                                                    placeholder="Time"
                                                    style={{ height: "55px" }}
                                                />
                                            </div>
                                        </div>
                                        <div className="col-12">
                                            <button
                                                className="btn btn-primary w-100 py-3"
                                                type="submit"
                                            >
                                                Make An Appointment
                                            </button>
                                        </div>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            {/* Appointment End */}
        </>
    );
};

export default Home;
