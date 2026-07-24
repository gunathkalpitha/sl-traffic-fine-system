import React from 'react';
import './SubmitButton.css';


function SubmitButton({ children, loading = false, disabled = false, onClick, type = 'button' }) {
  return (
    <button
      type={type}
      className="submit-btn"
      disabled={disabled || loading}
      onClick={onClick}
    >
      {loading ? <span className="submit-btn__spinner" /> : children}
    </button>
  );
}

export default SubmitButton;