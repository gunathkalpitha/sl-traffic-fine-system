import React from 'react';
import './ErrorAlert.css';


function ErrorAlert({ message }) {
  if (!message) return null;
  return (
    <div className="error-alert" role="alert">
      <span className="error-alert__icon">⚠️</span>
      <span>{message}</span>
    </div>
  );
}

export default ErrorAlert;