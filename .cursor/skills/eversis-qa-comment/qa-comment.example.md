### 📝 QA Summary

**Task Context:** Implementation of multi-factor authentication (MFA) toggle in user settings.

**Main Changes:**
- Added a new section in User Settings to manage security preferences.
- Implemented a toggle switch to enable/disable MFA via Email.
- Updated the login flow to challenge the user for a code if MFA is active.
- Added descriptive error messages for invalid or expired MFA codes.

---

**✅ Verification List:**

**Manual Testing:**
- [ ] Navigate to Settings -> Security and verify the MFA toggle is visible.
- [ ] Enable MFA and logout. Verify that the system asks for an email code during the next login.
- [ ] Test the "Resend Code" functionality to ensure it triggers a new email.
- [ ] Verify that disabling MFA removes the extra step during login.

**Automation & Technical Notes:**
- **Selectors**: The MFA toggle can be targeted via `data-testid="mfa-toggle-switch"`.
- **API**: New endpoint `POST /api/v1/auth/mfa/verify` handles code validation.
- **Error Handling**: Invalid codes return a `422 Unprocessable Entity` with a `code_expired` or `code_invalid` reason.
