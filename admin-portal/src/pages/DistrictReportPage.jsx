 import React, { useEffect, useState } from 'react';
import { BarChart, Bar, XAxis, YAxis, CartesianGrid, Tooltip, ResponsiveContainer } from 'recharts';
import Navbar from '../components/Navbar';
import { getDistrictReport } from '../services/reportService';

function DistrictReportPage() {
  const [data, setData] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState('');

  useEffect(() => {
    getDistrictReport()
      .then(res => setData(res.data))
      .catch(() => setError('Failed to load district data.'))
      .finally(() => setLoading(false));
  }, []);

  return (
    <div style={styles.page}>
      <Navbar />
      <div style={styles.content}>
        <h2 style={styles.heading}>District-wise Collections</h2>

        {loading && <p>Loading...</p>}
        {error && <p style={{ color: '#c62828' }}>{error}</p>}

        {data.length > 0 && (
          <>
            <div style={styles.chartBox}>
              <ResponsiveContainer width="100%" height={320}>
                <BarChart data={data} margin={{ top: 10, right: 30, left: 20, bottom: 5 }}>
                  <CartesianGrid strokeDasharray="3 3" />
                  <XAxis dataKey="districtName" tick={{ fontSize: 12 }} />
                  <YAxis tick={{ fontSize: 12 }} />
                  <Tooltip formatter={val => `Rs. ${val.toLocaleString()}`} />
                  <Bar dataKey="totalAmount" fill="#1a237e" radius={[4, 4, 0, 0]} />
                </BarChart>
              </ResponsiveContainer>
            </div>

            <table style={styles.table}>
              <thead>
                <tr style={styles.thead}>
                  <th style={styles.th}>District</th>
                  <th style={styles.th}>Total Fines Paid</th>
                  <th style={styles.th}>Total Amount (Rs.)</th>
                </tr>
              </thead>
              <tbody>
                {data.map((row, i) => (
                  <tr key={i} style={i % 2 === 0 ? styles.rowEven : styles.rowOdd}>
                    <td style={styles.td}>{row.districtName}</td>
                    <td style={styles.td}>{row.totalFines}</td>
                    <td style={styles.td}>Rs. {row.totalAmount?.toLocaleString()}</td>
                  </tr>
                ))}
              </tbody>
            </table>
          </>
        )}
      </div>
    </div>
  );
}

const styles = {
  page: { minHeight: '100vh', background: '#f0f2f5' },
  content: { padding: '32px' },
  heading: { fontSize: '22px', fontWeight: '700', color: '#1a237e', marginBottom: '24px' },
  chartBox: {
    background: '#fff',
    borderRadius: '10px',
    padding: '24px',
    marginBottom: '28px',
    boxShadow: '0 2px 8px rgba(0,0,0,0.08)',
  },
  table: { width: '100%', borderCollapse: 'collapse', background: '#fff', borderRadius: '10px', overflow: 'hidden', boxShadow: '0 2px 8px rgba(0,0,0,0.08)' },
  thead: { background: '#1a237e' },
  th: { padding: '14px 20px', color: '#fff', textAlign: 'left', fontSize: '13px', fontWeight: '600' },
  td: { padding: '12px 20px', fontSize: '14px', color: '#333' },
  rowEven: { background: '#fff' },
  rowOdd: { background: '#f5f5f5' },
};

export default DistrictReportPage;