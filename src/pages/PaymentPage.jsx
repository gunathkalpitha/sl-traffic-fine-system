import React from 'react';
import { useLocation, useNavigate } from 'react-router-dom';
import PaymentForm from '../components/PaymentForm';


function PaymentPage() {
  const location = useLocation();
  const navigate = useNavigate();

  const fineData = location.state?.fineData;

  // Guard: if someone navigates here directly without fineData
  if (!fineData) {
    return (
      <>
        <div className="stepper">
          <div className="stepper__step stepper__step--done">1. Fine Lookup</div>
          <div className="stepper__step stepper__step--active">2. Payment Details</div>
          <div className="stepper__step">3. Confirmation</div>
        </div>
        <div className="page-card">
          <p>No fine data found. <a href="/pay">Go back to fine lookup.</a></p>
        </div>
      </>
    );
  }

  function handlePaymentSuccess(responseData) {
    navigate('/confirmation', {
      state: {
        receiptData: {
          ...responseData,
          referenceNumber: fineData.referenceNumber,
          amount: fineData.amount,
          categoryCode: fineData.categoryCode,
          vehicleNumber: fineData.vehicleNumber,
        },
      },
    });
  }

  return (
    <>
      <div className="stepper">
        <div className="stepper__step stepper__step--done">1. Fine Lookup</div>
        <div className="stepper__step stepper__step--active">2. Payment Details</div>
        <div className="stepper__step">3. Confirmation</div>
      </div>

      <div className="page-card">
        <h1 className="page-card__title">Payment Details</h1>
        <p className="page-card__subtitle">Enter your card details to complete the payment.</p>
        <PaymentForm fineData={fineData} onPaymentSuccess={handlePaymentSuccess} />
      </div>
    </>
  );
}

export default PaymentPage;