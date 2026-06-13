import React from 'react';
import './ConfirmationCard.css';


function ConfirmationCard({ receiptData }) {
  const {
    receiptNumber,
    paidAt,
    message,
    referenceNumber,
    amount,
    categoryCode,
    vehicleNumber,
  } = receiptData;

  return (
    <div className="confirmation-card">
      <div className="confirmation-card__icon">✅</div>
      <h2 className="confirmation-card__heading">Payment Successful</h2>
      <p className="confirmation-card__message">{message || 'Your fine has been paid successfully.'}</p>

      <div className="confirmation-card__receipt">
        <p className="confirmation-card__receipt-title">Receipt</p>
        <dl className="confirmation-card__list">
          <div className="confirmation-card__row">
            <dt>Receipt No.</dt>
            <dd>{receiptNumber}</dd>
          </div>
          <div className="confirmation-card__row">
            <dt>Reference No.</dt>
            <dd>{referenceNumber}</dd>
          </div>
          <div className="confirmation-card__row">
            <dt>Category</dt>
            <dd>{categoryCode}</dd>
          </div>
          <div className="confirmation-card__row">
            <dt>Vehicle No.</dt>
            <dd>{vehicleNumber}</dd>
          </div>
          <div className="confirmation-card__row">
            <dt>Amount Paid</dt>
            <dd>LKR {Number(amount).toLocaleString()}</dd>
          </div>
          <div className="confirmation-card__row">
            <dt>Paid At</dt>
            <dd>{new Date(paidAt).toLocaleString()}</dd>
          </div>
        </dl>
      </div>

      <p className="confirmation-card__sms-note">
         An SMS notification has been sent to the issuing officer.
      </p>
    </div>
  );
}

export default ConfirmationCard;