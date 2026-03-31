# SE Validation Feedback — Prevent Lateral Movement - VM Tags

**Blueprint:** Prevent Lateral Movement - VM Tags
**Repo:** https://github.com/tatiLogg/aviatrix-blueprints
**Branch:** `feat/zero-trust-segmentation`
**Directory:** `blueprints/prevent-lateral-movement-vm-tags/`

Please complete this form after deploying and testing the blueprint. Return to Selina Loggins when done.

---

## Reviewer Information

| Field | Your Response |
|-------|---------------|
| **Name** | |
| **Date Tested** | |
| **Aviatrix Controller Version** | |
| **Terraform Version** | |
| **AWS Region Used** | |

---

## Section 1: Deployment Experience

### 1.1 Prerequisites

| Question | Response |
|----------|----------|
| Were the prerequisites clearly documented? | Yes / No / Partial |
| Did you have everything you needed before starting? | Yes / No |
| Was anything missing from the prerequisites list? | |

### 1.2 Deployment Steps

| Question | Response |
|----------|----------|
| Were you able to deploy successfully end-to-end? | Yes / No |
| If no, at which step did it fail? | |
| How long did the full deployment take? | |
| Were the deployment instructions easy to follow? (1–5) | |
| Any steps that were unclear or confusing? | |

### 1.3 Errors Encountered

| Error | Step Where It Occurred | How You Resolved It |
|-------|----------------------|---------------------|
| | | |
| | | |

---

## Section 2: Test Scenarios

Please run each scenario and record your results:

| Scenario | Expected Result | Actual Result | Pass/Fail |
|----------|----------------|---------------|-----------|
| Dev → DB (should be BLOCKED) | Ping times out | | |
| Prod → DB (should be ALLOWED) | Ping succeeds | | |
| Dev → Prod ICMP (should be ALLOWED) | Ping succeeds | | |
| Dev → Prod TCP (should be BLOCKED) | Connection times out | | |
| Prod → Dev (should be BLOCKED) | Ping times out | | |

### Gatus Dashboard

| Question | Response |
|----------|----------|
| Did the Gatus dashboard load successfully? | Yes / No |
| Did the green/red tiles reflect the correct DCF enforcement? | Yes / No / Partial |
| How long did it take for Gatus to become available after `terraform apply`? | |

### CoPilot Verification

| Question | Response |
|----------|----------|
| Could you see all gateways in CoPilot Topology? | Yes / No |
| Did DCF Monitor show DENIED/PERMITTED entries correctly? | Yes / No |
| Were SmartGroups populated with the correct VMs? | Yes / No |

---

## Section 3: Usability

Rate each area 1–5 (1 = very poor, 5 = excellent):

| Area | Rating (1–5) | Comments |
|------|-------------|----------|
| Overall ease of deployment | | |
| Clarity of README documentation | | |
| Quality of test scenarios | | |
| Usefulness of Gatus dashboard for demos | | |
| Demo walkthrough / talking points | | |
| Troubleshooting guidance | | |

---

## Section 4: Accuracy & Effectiveness

| Question | Response |
|----------|----------|
| Did the blueprint accurately demonstrate lateral movement prevention? | Yes / No / Partial |
| Would this blueprint be effective in a customer-facing demo? | Yes / No / With changes |
| Does the architecture reflect real-world customer use cases? | Yes / No / Partial |
| Are the claimed outcomes (15 min deploy, 80% faster, etc.) accurate? | Yes / No / Overstated |

---

## Section 5: Feedback & Recommendations

### What worked well?

_Please describe 2–3 things that stood out positively:_

1.
2.
3.

### What needs improvement?

_Please describe any issues, gaps, or areas to fix:_

1.
2.
3.

### Would you use this blueprint with a customer?

- [ ] Yes, as-is
- [ ] Yes, with minor changes (describe below)
- [ ] No, needs significant rework (describe below)

**Comments:**

### Additional Notes

_Any other feedback, suggestions, or observations:_

---

## Validation Sign-off

By completing this form, I confirm that I have deployed and tested the blueprint as described above.

| Field | |
|-------|-|
| **SE Name** | |
| **Signature / Initials** | |
| **Date** | |

---

*Return completed form to Selina Loggins. Thank you for your time and feedback!*
