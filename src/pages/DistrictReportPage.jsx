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
    <>
      <Navbar />
      <div className="page-container">
        <div className="page-header">
          <div>
            <h1 className="page-title">District-wise Collections</h1>
            <p className="page-subtitle">Total fines and amounts collected per district.</p>
          </div>
        </div>

        {loading && <p>Loading...</p>}
        {error && <div className="login-error">{error}</div>}

        {data.length > 0 && (
          <>
            <div className="card" style={{ marginBottom: '32px' }}>
              <h2 className="card-title">Collection Overview</h2>
              <div style={{ height: '320px', width: '100%' }}>
                <ResponsiveContainer width="100%" height="100%">
                  <BarChart data={data} margin={{ top: 10, right: 30, left: 20, bottom: 5 }}>
                    <CartesianGrid strokeDasharray="3 3" vertical={false} stroke="#e2e8f0" />
                    <XAxis dataKey="districtName" tick={{ fontSize: 12, fill: 'var(--text-muted)' }} axisLine={false} tickLine={false} />
                    <YAxis tick={{ fontSize: 12, fill: 'var(--text-muted)' }} axisLine={false} tickLine={false} />
                    <Tooltip formatter={val => `Rs. ${val.toLocaleString()}`} cursor={{ fill: 'rgba(0,0,0,0.02)' }} />
                    <Bar dataKey="totalAmount" fill="var(--accent-color)" radius={[4, 4, 0, 0]} />
                  </BarChart>
                </ResponsiveContainer>
              </div>
            </div>

            <div className="table-container">
              <table>
                <thead>
                  <tr>
                    <th>District</th>
                    <th>Total Fines Paid</th>
                    <th>Total Amount (Rs.)</th>
                  </tr>
                </thead>
                <tbody>
                  {data.map((row, i) => (
                    <tr key={i}>
                      <td style={{ fontWeight: 500 }}>{row.districtName}</td>
                      <td>{row.totalFines}</td>
                      <td style={{ fontWeight: 600 }}>Rs. {row.totalAmount?.toLocaleString()}</td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>
          </>
        )}
      </div>
    </>
  );
}

export default DistrictReportPage;