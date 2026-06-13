import React from 'react';
import { useNavigate } from 'react-router-dom';
import FineEntryForm from '../components/FineEntryForm';


function FineEntryPage() {
  const navigate = useNavigate();

  function handleFineLookupSuccess(fineData) {
    // Pass fineData to the next page via router state
    navigate('/payment', { state: { fineData } });
  }

  return (
    <>
      <div className="stepper">
        <div className="stepper__step stepper__step--active">1. Fine Lookup</div>
        <div className="stepper__step">2. Payment Details</div>
        <div className="stepper__step">3. Confirmation</div>
      </div>

      <div className="page-card">
        <h1 className="page-card__title">Enter Fine Reference</h1>
        <p className="page-card__subtitle">Enter the reference number from your traffic fine sheet.</p>
        <FineEntryForm onFineLookupSuccess={handleFineLookupSuccess} />
      </div>
    </>
  );
}

export default FineEntryPage;