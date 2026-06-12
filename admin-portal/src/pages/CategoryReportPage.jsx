 import React, { useEffect, useState } from 'react';
import { PieChart, Pie, Cell, Tooltip, Legend, ResponsiveContainer } from 'recharts';
import Navbar from '../components/Navbar';
import { getCategoryReport } from '../services/reportService';

const COLORS = ['#1a237e', '#1565c0', '#0288d1', '#00838f', '#2e7d32', '#f57c00', '#6a1b9a', '#c62828'];

function CategoryReportPage() {
  const [data, setData] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState('');

  useEffect(() => {
    getCategoryReport()
      .then(res => setData(res.data))
      .catch(() => setError('Failed to load category data.'))
      .finally(() => setLoading(false));
  }, []);

  const chartData = data.map(item => ({
    name: item.categoryDescription,
    value: item.totalAmount,
  }));

  return (
    <div style={styles.page}>
      <Navbar />
      <div style={styles.content}>
        <h2 style={styles.heading}>Fine Category Breakdown</h2>

        {loading && <p>Loading...</p>}
        {error && <p style={{ color: '#c62828' }}>{error}</p>}

        {data.length > 0 && (
          <div style={styles.layout}>
            <div style={styles.chartBox}>
              <ResponsiveContainer width="100%" height={340}>
                <PieChart>
                  <Pie data={chartData} dataKey="value" nameKey="name" cx="50%" cy="50%" outerRadius={120} label>
                    {chartData.map((_, i) => (
                      <Cell key={i} fill={COLORS[i % COLORS.length]} />
                    ))}
                  </Pie>
                  <Tooltip formatter={val => `Rs. ${val.toLocaleString()}`} />
                  <Legend />
                </PieChart>
              </ResponsiveContainer>
            </div>

            <table style={styles.table}>
              <thead>
                <tr style={styles.thead}>
                  <th style={styles.th}>Category</th>
                  <th style={styles.th}>Code</th>
                  <th style={styles.th}>Fines Paid</th>
                  <th style={styles.th}>Total (Rs.)</th>
                </tr>
              </thead>
              <tbody>
                {data.map((row, i) => (
                  <tr key={i} style={i % 2 === 0 ? styles.rowEven : styles.rowOdd}>
                    <td style={styles.td}>{row.categoryDescription}</td>
                    <td style={styles.td}>{row.categoryCode}</td>
                    <td style={styles.td}>{row.totalFines}</td>
                    <td style={styles.td}>Rs. {row.totalAmount?.toLocaleString()}</td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        )}
      </div>
    </div>
  );
}

const styles = {
  page: { minHeight: '100vh', background: '#f0f2f5' },
  content: { padding: '32px' },
  heading: { fontSize: '22px', fontWeight: '700', color: '#1a237e', marginBottom: '24px' },
  layout: { display: 'flex', gap: '28px', flexWrap: 'wrap' },
  chartBox: {
    background: '#fff',
    borderRadius: '10px',
    padding: '24px',
    boxShadow: '0 2px 8px rgba(0,0,0,0.08)',
    flex: '1',
    minWidth: '300px',
  },
  table: { flex: '1', minWidth: '300px', borderCollapse: 'collapse', background: '#fff', borderRadius: '10px', overflow: 'hidden', boxShadow: '0 2px 8px rgba(0,0,0,0.08)', alignSelf: 'flex-start' },
  thead: { background: '#1a237e' },
  th: { padding: '14px 20px', color: '#fff', textAlign: 'left', fontSize: '13px', fontWeight: '600' },
  td: { padding: '12px 20px', fontSize: '14px', color: '#333' },
  rowEven: { background: '#fff' },
  rowOdd: { background: '#f5f5f5' },
};

export default CategoryReportPage;