import React from 'react';

import styles from './styles.module.css';

/* ── Inline SVG icon components ─────────────────────────────── */

function IconLifecycle() {
  return (
    <svg className={styles.cardIcon} viewBox="0 0 36 36" fill="none">
      <path d="M6 18h24M18 6v24" stroke="rgba(255,255,255,0.5)" strokeWidth="2" strokeLinecap="round" />
      <circle cx="18" cy="18" r="4" fill="rgba(255,255,255,0.15)" stroke="rgba(255,255,255,0.5)" strokeWidth="1.5" />
    </svg>
  );
}

function IconAgents() {
  return (
    <svg className={styles.cardIcon} viewBox="0 0 36 36" fill="none">
      <rect x="6" y="10" width="10" height="10" rx="2" stroke="rgba(255,255,255,0.5)" strokeWidth="1.5" />
      <rect x="20" y="10" width="10" height="10" rx="2" stroke="rgba(255,255,255,0.5)" strokeWidth="1.5" />
      <rect x="13" y="22" width="10" height="10" rx="2" stroke="rgba(255,255,255,0.5)" strokeWidth="1.5" />
      <path d="M11 20l7 2 7-2" stroke="rgba(255,255,255,0.3)" strokeWidth="1.2" strokeLinecap="round" />
    </svg>
  );
}

function IconWorkflow() {
  return (
    <svg className={styles.cardIcon} viewBox="0 0 36 36" fill="none">
      <path d="M8 12h20M8 18h14M8 24h17" stroke="rgba(255,255,255,0.5)" strokeWidth="2" strokeLinecap="round" />
    </svg>
  );
}

function IconVerification() {
  return (
    <svg className={styles.cardIcon} viewBox="0 0 36 36" fill="none">
      <path d="M10 18l6 6 10-10" stroke="rgba(255,255,255,0.5)" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round" />
      <circle cx="18" cy="18" r="11" stroke="rgba(255,255,255,0.25)" strokeWidth="1.5" />
    </svg>
  );
}

function IconRequirements() {
  return (
    <svg className={styles.cardIcon} viewBox="0 0 36 36" fill="none">
      <path d="M10 12h16v3H10zM10 19h16v3H10zM10 26h10v3H10z" fill="rgba(255,255,255,0.15)" stroke="rgba(255,255,255,0.4)" strokeWidth="1.2" />
      <circle cx="29" cy="28" r="4" fill="rgba(255,255,255,0.1)" stroke="rgba(255,255,255,0.5)" strokeWidth="1.5" />
      <path d="M27.5 28l1 1 2-2" stroke="rgba(255,255,255,0.7)" strokeWidth="1.2" strokeLinecap="round" />
    </svg>
  );
}

function IconIntegrations() {
  return (
    <svg className={styles.cardIcon} viewBox="0 0 36 36" fill="none">
      <path d="M18 6l3 8h9l-7 5 3 8-8-5-8 5 3-8-7-5h9z" stroke="rgba(255,255,255,0.5)" strokeWidth="1.5" fill="rgba(255,255,255,0.08)" strokeLinejoin="round" />
    </svg>
  );
}

/* ── Card data ──────────────────────────────────────────────── */

type CardItem = {
  icon: React.ReactNode;
  title: string;
  description: string;
};

const cards: CardItem[] = [
  {
    icon: <IconLifecycle />,
    title: 'End-to-End Product Lifecycle',
    description:
      'Covers Product Ideation, Development, and Quality in a single framework. From workshop transcript to production-ready code — every phase has dedicated agents, skills, and workflows.',
  },
  {
    icon: <IconAgents />,
    title: '10 Specialized AI Agents',
    description:
      'Business Analyst, Architect, Software Engineer, Code Reviewer, UI Reviewer, E2E Engineer, DevOps Engineer, Context Engineer, Copilot Engineer, and Copilot Orchestrator — each focused on its phase, working together in a structured sequence.',
  },
  {
    icon: <IconWorkflow />,
    title: 'Structured Delivery Workflow',
    description:
      'Research → Plan → Implement → Review. Each phase feeds the next. Research becomes the plan. The plan becomes the implementation checklist. Review returns issues to the exact phase.',
  },
  {
    icon: <IconVerification />,
    title: 'Pixel-Perfect UI Verification',
    description:
      'Automated Figma comparison loop in every UI implementation cycle. Playwright captures the rendered state and compares it to the design spec. Mismatches are fixed before review.',
  },
  {
    icon: <IconRequirements />,
    title: 'Requirements Processing',
    description:
      'Turn workshop transcripts and meeting notes into Jira-ready user stories before a line of code is written. The framework starts at the source of the work, not just the ticket.',
  },
  {
    icon: <IconIntegrations />,
    title: 'MCP Tool Integrations',
    description:
      'Jira, Figma Dev Mode, Context7, Playwright, Sequential Thinking, AWS API, GCP Gcloud, and more — wired into the workflow phases, not bolted on. Context flows through every step automatically.',
  },
];

/* ── Component ──────────────────────────────────────────────── */

export default function HomepageFeatures(): React.JSX.Element {
  return (
    <section className={styles.framework}>
      <div className={styles.frameworkInner}>
        <div className={styles.frameworkLabel}>
          A complete AI
          <br />
          product engineering
          <br />
          framework — not
          <br />
          just a set of prompts
        </div>
        <div className={styles.cardsGrid}>
          {cards.map((card) => (
            <div key={card.title} className={styles.cardDark}>
              {card.icon}
              <h3>{card.title}</h3>
              <p>{card.description}</p>
            </div>
          ))}
        </div>
      </div>
    </section>
  );
}
