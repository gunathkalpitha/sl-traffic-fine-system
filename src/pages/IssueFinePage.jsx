import React, { useState, useEffect } from 'react';
import Navbar from '../components/Navbar';
import { getCategories, getDistricts, getOfficers, issueFine } from '../services/fineService';

function IssueFinePage() {
  const [categories, setCategories] = useState([]);
  const [districts, setDistricts] = useState([]);
  const [officers, setOfficers] = useState([]);
  
  const [formData, setFormData] = useState({
    categoryId: '',
    districtId: '',
    officerId: '',
    vehicleNumber: '',
    driverName: '',
    driverEmail: '',
    driverPhone: '',
  });

  const [loading, setLoading] = useState(false);
  const [message, setMessage] = useState({ type: '', text: '' });

  useEffect(() => {
    // Fetch options on mount
    Promise.all([
      getCategories(),
      getDistricts(),
      getOfficers()
    ]).then(([catRes, distRes, offRes]) => {
      setCategories(catRes.data);
      setDistricts(distRes.data);
      setOfficers(offRes.data);
    }).catch(err => {
      console.error("Failed to load options", err);
      setMessage({ type: 'error', text: 'Failed to load form options from server.' });
    });
  }, []);

  const handleChange = (e) => {
    setFormData({ ...formData, [e.target.name]: e.target.value });
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    setLoading(true);
    setMessage({ type: '', text: '' });

    try {
      const selectedCategory = categories.find(c => c.id === formData.categoryId);
      const dataToSubmit = {
        ...formData,
        categoryName: selectedCategory?.name,
        amount: selectedCategory?.fineAmount,
        description: selectedCategory?.name
      };

      const response = await issueFine(dataToSubmit);
      setMessage({ type: 'success', text: `Fine Issued successfully! Ref: ${response.data.referenceNumber}` });
      setFormData({
        categoryId: '',
        districtId: '',
        officerId: '',
        vehicleNumber: '',
        driverName: '',
        driverEmail: '',
        driverPhone: '',
      });
    } catch (err) {
      console.error(err);
      setMessage({ type: 'error', text: err.response?.data || err.message || 'Failed to issue fine.' });
    }
    setLoading(false);
  };

  return (
    <>
      <Navbar />
      <div className="issue-fine-page">
        {/* Left decorative sidebar */}
        <div className="issue-fine-sidebar">
          <div className="issue-fine-brand">
            <span className="issue-fine-brand-logo">👮</span>
            <span className="issue-fine-brand-name">SL Traffic Police</span>
          </div>
          <div className="issue-fine-sidebar-content">
            <h2 className="issue-fine-sidebar-title">Digital Violation Enforcement</h2>
            <p className="issue-fine-sidebar-text">
              Log real-time violations instantly. Fines issued here are synchronized immediately with driver profiles, sending automated SMS notifications to drivers and officers.
            </p>
            <div className="issue-fine-features">
              <div className="issue-fine-feature-item">
                <div className="issue-fine-feature-icon">🛡️</div>
                <div className="issue-fine-feature-text">Secure & Auditable Transactions</div>
              </div>
              <div className="issue-fine-feature-item">
                <div className="issue-fine-feature-icon">⚡</div>
                <div className="issue-fine-feature-text">Instant Mobile App Sync & Billing</div>
              </div>
              <div className="issue-fine-feature-item">
                <div className="issue-fine-feature-icon">✉️</div>
                <div className="issue-fine-feature-text">Automated Email & SMS Receipts</div>
              </div>
            </div>
          </div>
        </div>

        {/* Right side form container */}
        <div className="issue-fine-form-container">
          <div className="issue-fine-card">
            <h2 className="issue-fine-form-title">Issue Traffic Ticket</h2>
            <p className="issue-fine-form-subtitle">Ensure all driver and vehicle records are verified before submitting.</p>

            {message.text && (
              <div className="login-error" style={{ 
                background: message.type === 'success' ? 'rgba(16, 185, 129, 0.15)' : 'rgba(239, 68, 68, 0.15)',
                color: message.type === 'success' ? '#34d399' : '#f87171',
                borderColor: message.type === 'success' ? '#059669' : '#dc2626',
                marginBottom: '20px'
               }}>
                {message.text}
              </div>
            )}

            <form onSubmit={handleSubmit}>
              <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: '20px' }}>
                <div className="input-group">
                  <label>Vehicle Number</label>
                  <input
                    type="text"
                    name="vehicleNumber"
                    placeholder="e.g. WP CAA-1234"
                    value={formData.vehicleNumber}
                    onChange={handleChange}
                    required
                    style={{ textTransform: 'uppercase' }}
                  />
                </div>

                <div className="input-group">
                  <label>Driver Name</label>
                  <input
                    type="text"
                    name="driverName"
                    placeholder="Full Name"
                    value={formData.driverName}
                    onChange={handleChange}
                    required
                  />
                </div>
              </div>

              <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: '20px' }}>
                <div className="input-group">
                  <label>Driver Email (Optional)</label>
                  <input
                    type="email"
                    name="driverEmail"
                    placeholder="driver@example.com"
                    value={formData.driverEmail}
                    onChange={handleChange}
                  />
                </div>

                <div className="input-group">
                  <label>Driver Phone (Optional)</label>
                  <input
                    type="text"
                    name="driverPhone"
                    placeholder="e.g. +94771234567"
                    value={formData.driverPhone}
                    onChange={handleChange}
                  />
                </div>
              </div>

              <div className="input-group">
                <label>Violation Category</label>
                <select name="categoryId" value={formData.categoryId} onChange={handleChange} required>
                  <option value="">-- Select Category --</option>
                  {categories.map(c => (
                    <option key={c.id} value={c.id}>{c.id} - {c.name} (Rs. {c.fineAmount})</option>
                  ))}
                </select>
              </div>

              <div className="input-group">
                <label>District</label>
                <select name="districtId" value={formData.districtId} onChange={handleChange} required>
                  <option value="">-- Select District --</option>
                  {districts.map(d => (
                    <option key={d.id} value={d.id}>{d.name} ({d.province})</option>
                  ))}
                </select>
              </div>

              <button type="submit" className="btn-primary" disabled={loading}>
                {loading ? 'Issuing...' : 'Issue Fine'}
              </button>
            </form>
          </div>
        </div>
      </div>
    </>
  );
}

export default IssueFinePage;
