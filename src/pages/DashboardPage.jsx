 import React, { useEffect, useState } from 'react';
import Navbar from '../components/Navbar';
import SummaryCard from '../components/SummaryCard';
import { getSummary } from '../services/reportService';

function DashboardPage() {
  const [summary, setSummary] = useState(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState('');

  useEffect(() => {
    getSummary()
      .then(res => setSummary(res.data))
      .catch(() => setError('Failed to load summary data.'))
      .finally(() => setLoading(false));
  }, []);

  return (
    <>
      <Navbar />
      <div className="page-container">
        <div className="page-header">
          <div>
            <h1 className="page-title">Dashboard Overview</h1>
            <p className="page-subtitle">Summary of traffic fines and collection metrics.</p>
          </div>
        </div>

        {loading && <p>Loading data...</p>}
        {error && <div className="login-error">{error}</div>}

        {summary && (
          <div style={{ display: 'grid', gridTemplateColumns: 'repeat(auto-fit, minmax(240px, 1fr))', gap: '20px', marginBottom: '32px' }}>
            <SummaryCard
              title="Total Collections"
              value={`Rs. ${summary.totalAmount?.toLocaleString() ?? 0}`}
              icon="💰"
              color="var(--primary-color)"
            />
            <SummaryCard
              title="Total Fines Paid"
              value={summary.totalPaid ?? 0}
              icon="✅"
              color="var(--success-color)"
            />
            <SummaryCard
              title="Pending Fines"
              value={summary.totalPending ?? 0}
              icon="⏳"
              color="var(--warning-color)"
            />
            <SummaryCard
              title="Active Districts"
              value={summary.totalDistricts ?? 0}
              icon="🗺️"
              color="var(--accent-color)"
            />
          </div>
        )}

        <div className="card" style={{ background: '#f8fafc', border: '1px dashed var(--border-color)', display: 'flex', alignItems: 'center', gap: '12px' }}>
          <span style={{ fontSize: '24px' }}>📌</span>
          <div>
            <h3 style={{ margin: '0 0 4px', fontSize: '15px' }}>Quick Actions</h3>
            <p style={{ margin: 0, fontSize: '14px', color: 'var(--text-muted)' }}>
              Use the navigation above to <strong>Issue New Fines</strong>, process payments, or view detailed reports.
            </p>
          </div>
        </div>
      </div>
    </>
  );
}

export default DashboardPage;