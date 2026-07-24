import axiosInstance from './axiosInstance';

/**
 * Look up a fine by its reference number.
 *
 * Returns a FineResponseDto:
 *   { referenceNumber, categoryCode, categoryDescription, amount,
 *     vehicleNumber, status, issuedAt }
 *
 * @param {string} referenceNumber
 * @returns {Promise<object>}
 */
export async function getFineByReferenceNumber(referenceNumber) {
  const response = await axiosInstance.get(`/api/fines/${referenceNumber}`);
  return response.data;
}