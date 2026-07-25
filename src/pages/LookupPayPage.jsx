import React, { useState } from 'react';
import Navbar from '../components/Navbar';
import { lookupFine, payFine } from '../services/fineService';

function LookupPayPage() {
  const [referenceNumber, setReferenceNumber] = useState('');
  const [fine, setFine] = useState(null);
  
  const [loading, setLoading] = useState(false);
  const [payLoading, setPayLoading] = useState(false);
  const [message, setMessage] = useState({ type: '', text: '' });
  const [paymentMethod, setPaymentMethod] = useState('CARD');

  const handleLookup = async (e) => {
    e.preventDefault();
    setLoading(true);
    setMessage({ type: '', text: '' });
    setFine(null);

    try {
      const response = await lookupFine(referenceNumber);
      setFine(response.data);
    } catch (err) {
      setMessage({ type: 'error', text: 'Fine not found or invalid reference number.' });
    }
    setLoading(false);
  };

  const handlePayment = async () => {
    setPayLoading(true);
    setMessage({ type: '', text: '' });
    
    try {
      await payFine({
        referenceNumber: fine.referenceNumber,
        categoryId: fine.category.id,
        paymentMethod
      });
      setMessage({ type: 'success', text: 'Payment processed successfully!' });
      setFine({ ...fine, status: 'PAID' });
    } catch (err) {
      setMessage({ type: 'error', text: err.response?.data || 'Failed to process payment.' });
    }
    setPayLoading(false);
  };

  return (
    <>
      <Navbar />
      <div className="page-container">
        <div className="page-header">
          <div>
            <h1 className="page-title">Lookup & Pay Fine</h1>
            <p className="page-subtitle">Search for a traffic fine and process payment.</p>
          </div>
        </div>

        <div style={{ display: 'flex', gap: '24px', flexWrap: 'wrap', alignItems: 'flex-start' }}>
          
          {/* Search Card */}
          <div className="card" style={{ flex: '1 1 300px', minWidth: '300px' }}>
            <h2 className="card-title">Search Fine</h2>
            
            <form onSubmit={handleLookup}>
              <div className="input-group">
                <label>Reference Number</label>
                <input
                  type="text"
                  placeholder="e.g. TF-1234567890"
                  value={referenceNumber}
                  onChange={e => setReferenceNumber(e.target.value)}
                  required
                />
              </div>
              <button type="submit" className="btn-primary" disabled={loading}>
                {loading ? 'Searching...' : 'Lookup Fine'}
              </button>
            </form>

            {message.text && (
              <div className={`login-error`} style={{ 
                marginTop: '20px',
                background: message.type === 'success' ? '#ecfdf5' : '#fef2f2',
                color: message.type === 'success' ? '#047857' : '#b91c1c',
                borderColor: message.type === 'success' ? '#6ee7b7' : '#fca5a5'
               }}>
                {message.text}
              </div>
            )}
          </div>

          {/* Result Card */}
          {fine && (
            <div className="card" style={{ flex: '2 1 400px', minWidth: '350px', animation: 'fadeUp 0.4s ease forwards' }}>
              <h2 className="card-title">Fine Details</h2>
              
              <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: '16px', marginBottom: '24px' }}>
                <div>
                  <div style={{ fontSize: '12px', color: 'var(--text-muted)' }}>Reference</div>
                  <div style={{ fontWeight: 600 }}>{fine.referenceNumber}</div>
                </div>
                <div>
                  <div style={{ fontSize: '12px', color: 'var(--text-muted)' }}>Status</div>
                  <span className={`badge ${fine.status === 'PAID' ? 'paid' : 'pending'}`}>
                    {fine.status}
                  </span>
                </div>
                <div>
                  <div style={{ fontSize: '12px', color: 'var(--text-muted)' }}>Vehicle & Driver</div>
                  <div>{fine.vehicleNumber}</div>
                  <div style={{ fontSize: '13px', color: 'var(--text-muted)' }}>{fine.driverName}</div>
                </div>
                <div>
                  <div style={{ fontSize: '12px', color: 'var(--text-muted)' }}>Amount</div>
                  <div style={{ fontWeight: 700, color: 'var(--danger-color)', fontSize: '18px' }}>
                    Rs. {fine.amount}
                  </div>
                </div>
                <div style={{ gridColumn: 'span 2' }}>
                  <div style={{ fontSize: '12px', color: 'var(--text-muted)' }}>Violation</div>
                  <div>{fine.category?.name}</div>
                  <div style={{ fontSize: '13px', color: 'var(--text-muted)' }}>{fine.category?.description}</div>
                </div>
              </div>

              {fine.status !== 'PAID' && (
                <div style={{ borderTop: '1px solid var(--border-color)', paddingTop: '20px' }}>
                  <h3 style={{ fontSize: '15px', marginBottom: '12px' }}>Process Payment</h3>
                  <div className="input-group">
                    <label>Payment Method</label>
                    <select value={paymentMethod} onChange={e => setPaymentMethod(e.target.value)}>
                      <option value="CARD">Credit/Debit Card</option>
                      <option value="CASH">Cash</option>
                      <option value="BANK_TRANSFER">Bank Transfer</option>
                    </select>
                  </div>
                  <button 
                    className="btn-primary" 
                    style={{ background: 'var(--success-color)' }}
                    onClick={handlePayment}
                    disabled={payLoading}
                  >
                    {payLoading ? 'Processing...' : `Pay Rs. ${fine.amount}`}
                  </button>
                </div>
              )}
            </div>
          )}

        </div>
      </div>
    </>
  );
}

export default LookupPayPage;
