import React, { useState, useEffect } from 'react';
import axios from 'axios';
import { useAuth } from '../context/AuthContext';
import PaymentModal from '../components/PaymentModal';

function Dashboard() {
  const { user, profile } = useAuth();
  const [fines, setFines] = useState([]);
  const [stats, setStats] = useState({ pendingCount: 0, paidCount: 0, pendingAmount: 0.0 });
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState('');
  
  // Modal states
  const [selectedFine, setSelectedFine] = useState(null);
  const [isPaymentOpen, setIsPaymentOpen] = useState(false);
  const [isDetailsOpen, setIsDetailsOpen] = useState(false);

  // Search/Filter states
  const [searchQuery, setSearchQuery] = useState('');
  const [statusFilter, setStatusFilter] = useState('ALL');

  const fetchData = async () => {
    if (!user) return;
    setLoading(true);
    setError('');

    try {
      const email = user.email;
      const driverId = user.id;

      // 1. Fetch Stats
      const statsResponse = await axios.get(`http://localhost:8080/api/fines/driver/stats`, {
        params: { driverId, email }
      });
      setStats(statsResponse.data);

      // 2. Fetch Fines
      const finesResponse = await axios.get(`http://localhost:8080/api/fines/driver`, {
        params: { driverId, email }
      });
      setFines(finesResponse.data);
    } catch (err) {
      console.error(err);
      setError('Failed to fetch dashboard data. Please make sure the backend is running.');
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    fetchData();
  }, [user]);

  const handlePaymentSuccess = () => {
    fetchData();
  };

  // Filter logic
  const filteredFines = fines.filter(fine => {
    const matchesSearch = fine.referenceNumber?.toLowerCase().includes(searchQuery.toLowerCase()) ||
                          fine.categoryName?.toLowerCase().includes(searchQuery.toLowerCase()) ||
                          fine.location?.toLowerCase().includes(searchQuery.toLowerCase());
                          
    const matchesStatus = statusFilter === 'ALL' || fine.status === statusFilter;
    
    return matchesSearch && matchesStatus;
  });

  return (
    <div className="dashboard-container">
      <div className="dashboard-hero">
        <h1 className="dashboard-welcome">Ayubowan, {profile?.full_name || 'Driver'}!</h1>
        <p className="dashboard-instruction">Manage your traffic violations and pay tickets instantly.</p>
      </div>

      {error && <div className="dashboard-error-alert">{error}</div>}

      {/* Summary Cards */}
      <div className="stats-grid">
        <div className="stat-card stat-card--danger">
          <div className="stat-card__icon">💰</div>
          <div className="stat-card__details">
            <span className="stat-card__label">Total Outstanding Fines</span>
            <strong className="stat-card__value">LKR {stats.pendingAmount.toFixed(2)}</strong>
          </div>
        </div>

        <div className="stat-card stat-card--warning">
          <div className="stat-card__icon">⏳</div>
          <div className="stat-card__details">
            <span className="stat-card__label">Pending Tickets</span>
            <strong className="stat-card__value">{stats.pendingCount}</strong>
          </div>
        </div>

        <div className="stat-card stat-card--success">
          <div className="stat-card__icon">✅</div>
          <div className="stat-card__details">
            <span className="stat-card__label">Settled Tickets</span>
            <strong className="stat-card__value">{stats.paidCount}</strong>
          </div>
        </div>
      </div>

      {/* Fines Table Section */}
      <div className="fines-section card">
        <div className="fines-section-header">
          <h3 className="card-title">Violation History</h3>
          
          <div className="filters-row">
            <input
              type="text"
              placeholder="Search ref, category, location..."
              value={searchQuery}
              onChange={e => setSearchQuery(e.target.value)}
              className="search-input"
            />
            
            <select
              value={statusFilter}
              onChange={e => setStatusFilter(e.target.value)}
              className="status-filter-select"
            >
              <option value="ALL">All Fines</option>
              <option value="PENDING">Pending</option>
              <option value="PAID">Paid</option>
            </select>

            <button onClick={fetchData} className="btn-refresh" title="Reload data">
              🔄
            </button>
          </div>
        </div>

        {loading ? (
          <div className="table-loader">
            <span className="loader-spinner">🌀</span>
            <p>Loading your violations...</p>
          </div>
        ) : filteredFines.length === 0 ? (
          <div className="empty-fines-state">
            <span className="empty-fines-icon">🛡️</span>
            <h4>No Violations Found</h4>
            <p>Your record is clean! No fines found matching your search or filters.</p>
          </div>
        ) : (
          <div className="table-container">
            <table>
              <thead>
                <tr>
                  <th>Ref Number</th>
                  <th>Violation Category</th>
                  <th>Amount</th>
                  <th>Location</th>
                  <th>Issued Date</th>
                  <th>Status</th>
                  <th style={{ textAlign: 'right' }}>Actions</th>
                </tr>
              </thead>
              <tbody>
                {filteredFines.map(fine => (
                  <tr key={fine.id}>
                    <td>
                      <span className="fine-ref-number">{fine.referenceNumber}</span>
                    </td>
                    <td>{fine.categoryName || 'Traffic Violation'}</td>
                    <td>
                      <strong className="fine-amount">LKR {fine.amount.toFixed(2)}</strong>
                    </td>
                    <td>{fine.location}</td>
                    <td>
                      {fine.issuedAt ? new Date(fine.issuedAt).toLocaleDateString() : 'N/A'}
                    </td>
                    <td>
                      <span className={`badge ${fine.status?.toLowerCase()}`}>
                        {fine.status}
                      </span>
                    </td>
                    <td style={{ textAlign: 'right' }}>
                      <div className="action-buttons-group">
                        <button
                          onClick={() => {
                            setSelectedFine(fine);
                            setIsDetailsOpen(true);
                          }}
                          className="btn-secondary btn-sm"
                        >
                          Details
                        </button>
                        {fine.status === 'PENDING' && (
                          <button
                            onClick={() => {
                              setSelectedFine(fine);
                              setIsPaymentOpen(true);
                            }}
                            className="btn-primary btn-sm"
                          >
                            Pay Online
                          </button>
                        )}
                      </div>
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        )}
      </div>

      {/* Payment Modal */}
      {isPaymentOpen && selectedFine && (
        <PaymentModal
          fine={selectedFine}
          onClose={() => {
            setIsPaymentOpen(false);
            setSelectedFine(null);
          }}
          onSuccess={handlePaymentSuccess}
        />
      )}

      {/* Details Modal */}
      {isDetailsOpen && selectedFine && (
        <div className="modal-overlay">
          <div className="modal-card">
            <div className="modal-header">
              <h3 className="modal-title">Violation Record Details</h3>
              <button 
                onClick={() => {
                  setIsDetailsOpen(false);
                  setSelectedFine(null);
                }} 
                className="modal-close-btn"
              >
                &times;
              </button>
            </div>
            <div className="details-modal-content">
              <div className="detail-item">
                <span className="detail-item__label">Reference Number:</span>
                <strong className="detail-item__value">{selectedFine.referenceNumber}</strong>
              </div>
              <div className="detail-item">
                <span className="detail-item__label">Status:</span>
                <span className={`badge ${selectedFine.status?.toLowerCase()}`}>{selectedFine.status}</span>
              </div>
              <div className="detail-item">
                <span className="detail-item__label">Fine Amount:</span>
                <strong className="detail-item__value text-primary">LKR {selectedFine.amount.toFixed(2)}</strong>
              </div>
              <hr className="details-divider" />
              <div className="detail-item">
                <span className="detail-item__label">Violation Type:</span>
                <span className="detail-item__value">{selectedFine.categoryName || 'Traffic Violation'}</span>
              </div>
              <div className="detail-item">
                <span className="detail-item__label">Officer Badge:</span>
                <span className="detail-item__value">{selectedFine.officerBadge}</span>
              </div>
              <div className="detail-item">
                <span className="detail-item__label">Officer Name:</span>
                <span className="detail-item__value">{selectedFine.officerName}</span>
              </div>
              <div className="detail-item">
                <span className="detail-item__label">Location:</span>
                <span className="detail-item__value">{selectedFine.location}</span>
              </div>
              <div className="detail-item">
                <span className="detail-item__label">Issued At:</span>
                <span className="detail-item__value">
                  {selectedFine.issuedAt ? new Date(selectedFine.issuedAt).toLocaleString() : 'N/A'}
                </span>
              </div>
              <div className="detail-item">
                <span className="detail-item__label">Violator Info:</span>
                <span className="detail-item__value">
                  {selectedFine.violationDescription || 'N/A'}
                </span>
              </div>
            </div>
            <div className="modal-footer" style={{ display: 'flex', justifyContent: 'flex-end', gap: '10px', marginTop: '20px' }}>
              <button 
                onClick={() => {
                  setIsDetailsOpen(false);
                  setSelectedFine(null);
                }} 
                className="btn-secondary"
              >
                Close
              </button>
              {selectedFine.status === 'PENDING' && (
                <button
                  onClick={() => {
                    setIsDetailsOpen(false);
                    setIsPaymentOpen(true);
                  }}
                  className="btn-primary"
                >
                  Pay Online
                </button>
              )}
            </div>
          </div>
        </div>
      )}
    </div>
  );
}

export default Dashboard;
