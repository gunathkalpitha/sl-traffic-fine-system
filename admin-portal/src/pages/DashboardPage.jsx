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
    <div style={styles.page}>
      <Navbar />
      <div style={styles.content}>
        <h2 style={styles.heading}>Dashboard Overview</h2>

        {loading && <p style={styles.info}>Loading...</p>}
        {error && <p style={styles.errorText}>{error}</p>}

        {summary && (
          <div style={styles.cardRow}>
            <SummaryCard
              title="Total Collections"
              value={`Rs. ${summary.totalAmount?.toLocaleString() ?? 0}`}
              icon="💰"
              color="#1a237e"
            />
            <SummaryCard
              title="Total Fines Paid"
              value={summary.totalPaid ?? 0}
              icon="✅"
              color="#2e7d32"
            />
            <SummaryCard
              title="Pending Fines"
              value={summary.totalPending ?? 0}
              icon="⏳"
              color="#f57c00"
            />
            <SummaryCard
              title="Active Districts"
              value={summary.totalDistricts ?? 0}
              icon="🗺️"
              color="#6a1b9a"
            />
          </div>
        )}

        <div style={styles.infoBox}>
          <p>📌 Use the navigation above to view <strong>District Reports</strong> or <strong>Category Breakdowns</strong>.</p>
        </div>
      </div>
    </div>
  );
}

const styles = {
  page: { minHeight: '100vh', background: '#f0f2f5' },
  content: { padding: '32px' },
  heading: { fontSize: '22px', fontWeight: '700', color: '#1a237e', marginBottom: '24px' },
  cardRow: { display: 'flex', gap: '20px', flexWrap: 'wrap', marginBottom: '32px' },
  info: { color: '#555' },
  errorText: { color: '#c62828' },
  infoBox: {
    background: '#e8eaf6',
    borderRadius: '8px',
    padding: '18px 24px',
    color: '#3949ab',
    fontSize: '14px',
  },
};

export default DashboardPage;