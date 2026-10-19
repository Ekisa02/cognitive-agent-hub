# Security Notes

This reference implementation is intended for education and prototyping.

Recommendations for production use:
- Use audited plugin contracts only; maintain a registry of trusted plugin authors.
- Consider meta-transaction patterns and relayer security if you build UX layers.
- Add reentrancy protections if plugin calls interact with agent-owned funds or external assets.
- Use limiting/quotas and gas bounds on plugin interactions where appropriate.

