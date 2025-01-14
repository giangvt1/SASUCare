import React from "react";

const ForgotPassword = (onClose) => {
  return (
    <div className="d-flex justify-content-center bg-white forget-pass-form login">
      <form>
        <div className="close position-absolute" onClick={onClose}>
          ×
        </div>
        <h3 className="text-center mt-4">Forgot Password</h3>
        <table className="mt-4 mb-4">
          <tbody>
            <tr>
              <td>
                <b>Email</b>
              </td>
            </tr>
            <tr>
              <td>
                <input
                  className="input"
                  type="text"
                  name="email"
                  placeholder="Enter email"
                />
              </td>
            </tr>
            <tr>
              <td>
                <button className="button mt-4" type="submit">
                  Continue
                </button>
              </td>
            </tr>
          </tbody>
        </table>
      </form>
    </div>
  );
};

export default ForgotPassword;
