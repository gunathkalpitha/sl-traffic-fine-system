import React, { useState } from 'react';
import FormField from './FormField';
import SubmitButton from './SubmitButton';
import ErrorAlert from './ErrorAlert';
import FineDetailCard from './FineDetailCard';
import { submitPayment } from '../services/paymentService';
import './PaymentForm.css';

const PAYMENT_METHODS = [
  { value: 'CARD', label: 'Credit / Debit Card' },
  { value: 'ONLINE_BANKING', label: 'Online Banking' },
  { value: 'MOBILE_WALLET', label: 'Mobile Wallet' },
];


function PaymentForm({ fineData, onPaymentSuccess }) {
  const [paymentMethod, setPaymentMethod] = useState('CARD');
  const [cardNumber, setCardNumber] = useState('');
  const [cardHolder, setCardHolder] = useState('');
  const [expiryDate, setExpiryDate] = useState('');
  const [cvv, setCvv] = useState('');
  const [loading, setLoading] = useState(false);
  const [errorMessage, setErrorMessage] = useState(null);
  const [fieldErrors, setFieldErrors] = useState({});

  function validate() {
    const errors = {};
    if (!cardHolder.trim()) errors.cardHolder = 'Cardholder name is required.';
    if (!/^\d{16}$/.test(cardNumber.replace(/\s/g, ''))) errors.cardNumber = 'Enter a valid 16-digit card number.';
    if (!/^\d{2}\/\d{2}$/.test(expiryDate)) errors.expiryDate = 'Enter expiry as MM/YY.';
    if (!/^\d{3,4}$/.test(cvv)) errors.cvv = 'Enter a valid CVV.';
    setFieldErrors(errors);
    return Object.keys(errors).length === 0;
  }

  function formatCardNumber(value) {
    return value
      .replace(/\D/g, '')
      .slice(0, 16)
      .replace(/(.{4})/g, '$1 ')
      .trim();
  }

  function formatExpiry(value) {
    const digits = value.replace(/\D/g, '').slice(0, 4);
    if (digits.length >= 3) return `${digits.slice(0, 2)}/${digits.slice(2)}`;
    return digits;
  }

  async function handleSubmit(e) {
    e.preventDefault();
    if (!validate()) return;

    setLoading(true);
    setErrorMessage(null);

    // Build a mock transactionId from card last 4 digits + timestamp
    const last4 = cardNumber.replace(/\s/g, '').slice(-4);
    const transactionId = `TXN-${last4}-${Date.now()}`;

    const paymentRequestDto = {
      referenceNumber: fineData.referenceNumber,
      categoryCode: fineData.categoryCode,
      paymentMethod,
      transactionId,
    };

    try {
      const responseData = await submitPayment(paymentRequestDto);
      onPaymentSuccess(responseData);
    } catch (err) {
      const status = err?.response?.status;
      if (status === 409) {
        setErrorMessage('This fine has already been paid.');
      } else if (status === 404) {
        setErrorMessage('Fine reference not found. Please go back and check.');
      } else {
        setErrorMessage('Payment failed. Please check your details and try again.');
      }
    } finally {
      setLoading(false);
    }
  }

  return (
    <div>
      <FineDetailCard fineData={fineData} />

      <form onSubmit={handleSubmit} noValidate>
        {/* Payment method selector */}
        <div className="payment-form__method-group">
          <label className="payment-form__method-label">Payment Method</label>
          <div className="payment-form__methods">
            {PAYMENT_METHODS.map((m) => (
              <button
                key={m.value}
                type="button"
                className={`payment-form__method-btn${paymentMethod === m.value ? ' payment-form__method-btn--active' : ''}`}
                onClick={() => setPaymentMethod(m.value)}
              >
                {m.label}
              </button>
            ))}
          </div>
        </div>

        <FormField
          label="Cardholder Name"
          id="cardHolder"
          type="text"
          placeholder="Name as on card"
          value={cardHolder}
          onChange={(e) => setCardHolder(e.target.value)}
          error={fieldErrors.cardHolder}
          autoComplete="cc-name"
        />

        <FormField
          label="Card Number"
          id="cardNumber"
          type="text"
          placeholder="1234 5678 9012 3456"
          value={cardNumber}
          onChange={(e) => setCardNumber(formatCardNumber(e.target.value))}
          error={fieldErrors.cardNumber}
          inputMode="numeric"
          autoComplete="cc-number"
        />

        <div className="payment-form__row">
          <FormField
            label="Expiry Date"
            id="expiryDate"
            type="text"
            placeholder="MM/YY"
            value={expiryDate}
            onChange={(e) => setExpiryDate(formatExpiry(e.target.value))}
            error={fieldErrors.expiryDate}
            inputMode="numeric"
            autoComplete="cc-exp"
          />
          <FormField
            label="CVV"
            id="cvv"
            type="password"
            placeholder="•••"
            value={cvv}
            onChange={(e) => setCvv(e.target.value.replace(/\D/g, '').slice(0, 4))}
            error={fieldErrors.cvv}
            inputMode="numeric"
            autoComplete="cc-csc"
          />
        </div>

        <ErrorAlert message={errorMessage} />

        <SubmitButton type="submit" loading={loading}>
          Pay LKR {Number(fineData.amount).toLocaleString()}
        </SubmitButton>
      </form>
    </div>
  );
}

export default PaymentForm;