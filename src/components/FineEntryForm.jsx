import React, { useState } from 'react';
import FormField from './FormField';
import SubmitButton from './SubmitButton';
import ErrorAlert from './ErrorAlert';
import FineDetailCard from './FineDetailCard';
import { getFineByReferenceNumber } from '../services/fineService';
import './FineEntryForm.css';


function FineEntryForm({ onFineLookupSuccess }) {
  const [referenceNumber, setReferenceNumber] = useState('');
  const [fineData, setFineData] = useState(null);
  const [loading, setLoading] = useState(false);
  const [errorMessage, setErrorMessage] = useState(null);
  const [fieldError, setFieldError] = useState('');

  function validate() {
    if (!referenceNumber.trim()) {
      setFieldError('Reference number is required.');
      return false;
    }
    setFieldError('');
    return true;
  }

  async function handleLookup(e) {
    e.preventDefault();
    if (!validate()) return;

    setLoading(true);
    setErrorMessage(null);
    setFineData(null);

    try {
      const data = await getFineByReferenceNumber(referenceNumber.trim());

      if (data.status === 'PAID') {
        setErrorMessage('This fine has already been paid.');
        return;
      }

      setFineData(data);
    } catch (err) {
      const status = err?.response?.status;
      if (status === 404) {
        setErrorMessage('No fine found for that reference number. Please check and try again.');
      } else {
        setErrorMessage('Something went wrong. Please try again later.');
      }
    } finally {
      setLoading(false);
    }
  }

  function handleProceed() {
    onFineLookupSuccess(fineData);
  }

  return (
    <div>
      <form onSubmit={handleLookup} noValidate>
        <FormField
          label="Fine Reference Number"
          id="referenceNumber"
          type="text"
          placeholder="e.g. TF-2026-001234"
          value={referenceNumber}
          onChange={(e) => setReferenceNumber(e.target.value)}
          error={fieldError}
          autoFocus
        />

        <ErrorAlert message={errorMessage} />

        <SubmitButton type="submit" loading={loading}>
          Look Up Fine
        </SubmitButton>
      </form>

      {fineData && (
        <div className="fine-entry-form__result">
          <FineDetailCard fineData={fineData} />
          <SubmitButton onClick={handleProceed}>
            Proceed to Payment →
          </SubmitButton>
        </div>
      )}
    </div>
  );
}

export default FineEntryForm;