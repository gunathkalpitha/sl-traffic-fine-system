import React from 'react';
import './FormField.css';


function FormField({ label, id, error, ...rest }) {
  return (
    <div className="form-field">
      <label className="form-field__label" htmlFor={id}>
        {label}
      </label>
      <input
        id={id}
        className={`form-field__input${error ? ' form-field__input--error' : ''}`}
        {...rest}
      />
      {error && <span className="form-field__error">{error}</span>}
    </div>
  );
}

export default FormField;