 import React from 'react';
import { BrowserRouter, Routes, Route, Navigate } from 'react-router-dom';
import { AuthProvider, useAuth } from './context/AuthContext';
import LoginPage from './pages/LoginPage';
import DashboardPage from './pages/DashboardPage';
import DistrictReportPage from './pages/DistrictReportPage';
import CategoryReportPage from './pages/CategoryReportPage';
import IssueFinePage from './pages/IssueFinePage';
import LookupPayPage from './pages/LookupPayPage';
import ManageOfficersPage from './pages/ManageOfficersPage';
import SettingsPage from './pages/SettingsPage';

function ProtectedRoute({ children, allowedRoles }) {
  const { token, role } = useAuth();
  
  if (!token) return <Navigate to="/login" />;
  if (allowedRoles && !allowedRoles.includes(role)) {
    // If they are an officer trying to access admin, redirect to officer dashboard
    if (role === 'OFFICER') return <Navigate to="/issue-fine" replace />;
    // Otherwise, redirect to login to prevent infinite loops (since / requires ADMIN)
    return <Navigate to="/login" replace />;
  }
  return children;
}

function App() {
  return (
    <AuthProvider>
      <BrowserRouter>
        <Routes>
          <Route path="/login" element={<LoginPage />} />
          
          {/* Admin Routes */}
          <Route path="/" element={<ProtectedRoute allowedRoles={['ADMIN']}><DashboardPage /></ProtectedRoute>} />
          <Route path="/manage-officers" element={<ProtectedRoute allowedRoles={['ADMIN']}><ManageOfficersPage /></ProtectedRoute>} />
          <Route path="/districts" element={<ProtectedRoute allowedRoles={['ADMIN']}><DistrictReportPage /></ProtectedRoute>} />
          <Route path="/categories" element={<ProtectedRoute allowedRoles={['ADMIN']}><CategoryReportPage /></ProtectedRoute>} />
          
          {/* Officer & Admin Routes */}
          <Route path="/issue-fine" element={<ProtectedRoute allowedRoles={['ADMIN', 'OFFICER']}><IssueFinePage /></ProtectedRoute>} />
          <Route path="/lookup" element={<ProtectedRoute allowedRoles={['ADMIN', 'OFFICER']}><LookupPayPage /></ProtectedRoute>} />
          <Route path="/settings" element={<ProtectedRoute allowedRoles={['ADMIN', 'OFFICER']}><SettingsPage /></ProtectedRoute>} />
        </Routes>
      </BrowserRouter>
    </AuthProvider>
  );
}

export default App;