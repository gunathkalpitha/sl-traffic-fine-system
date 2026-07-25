import React from 'react';
import { useLocation, useNavigate } from 'react-router-dom';
import ConfirmationCard from '../components/ConfirmationCard';
import SubmitButton from '../components/SubmitButton';
import './ConfirmationPage.css';


function ConfirmationPage() {
  const location = useLocation();
  const navigate = useNavigate();

  const receiptData = location.state?.receiptData;

  if (!receiptData) {
    return (
      <>
        <div className="stepper">
          <div className="stepper__step stepper__step--done">1. Fine Lookup</div>
          <div className="stepper__step stepper__step--done">2. Payment Details</div>
          <div className="stepper__step stepper__step--active">3. Confirmation</div>
        </div>
        <div className="page-card">
          <p>No payment record found. <a href="/pay">Pay a fine.</a></p>
        </div>
      </>
    );
  }

  return (
    <>
      <div className="stepper">
        <div className="stepper__step stepper__step--done">1. Fine Lookup</div>
        <div className="stepper__step stepper__step--done">2. Payment Details</div>
        <div className="stepper__step stepper__step--active">3. Confirmation</div>
      </div>

      <div className="page-card">
        <ConfirmationCard receiptData={receiptData} />
        <div className="confirmation-page__actions">
          <button
            className="confirmation-page__print-btn"
            onClick={() => window.print()}
          >
             Print Receipt
          </button>
          <SubmitButton onClick={() => navigate('/pay')}>
            Pay Another Fine
          </SubmitButton>
        </div>
      </div>
    </>
  );
}

export default ConfirmationPage;