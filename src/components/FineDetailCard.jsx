import React from 'react';
import './FineDetailCard.css';


function FineDetailCard({ fineData }) {
  const {
    referenceNumber,
    categoryCode,
    categoryDescription,
    amount,
    vehicleNumber,
    status,
    issuedAt,
  } = fineData;

  return (
    <div className="fine-detail-card">
      <div className="fine-detail-card__header">
        <span className="fine-detail-card__label">Fine Details</span>
        <span className={`fine-detail-card__status fine-detail-card__status--${status?.toLowerCase()}`}>
          {status}
        </span>
      </div>

      <dl className="fine-detail-card__list">
        <div className="fine-detail-card__row">
          <dt>Reference No.</dt>
          <dd>{referenceNumber}</dd>
        </div>
        <div className="fine-detail-card__row">
          <dt>Category</dt>
          <dd>{categoryCode} — {categoryDescription}</dd>
        </div>
        <div className="fine-detail-card__row">
          <dt>Vehicle No.</dt>
          <dd>{vehicleNumber}</dd>
        </div>
        <div className="fine-detail-card__row">
          <dt>Issued At</dt>
          <dd>{new Date(issuedAt).toLocaleString()}</dd>
        </div>
        <div className="fine-detail-card__row fine-detail-card__row--amount">
          <dt>Amount Due</dt>
          <dd>LKR {Number(amount).toLocaleString()}</dd>
        </div>
      </dl>
    </div>
  );
}

export default FineDetailCard;