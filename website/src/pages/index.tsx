import React from 'react';
import Link from '@docusaurus/Link';
import useDocusaurusContext from '@docusaurus/useDocusaurusContext';
import Layout from '@theme/Layout';
import HomepageFeatures from '@site/src/components/HomepageFeatures';
import WorkflowShowcase from '@site/src/components/WorkflowShowcase';
import QuickWins from '@site/src/components/QuickWins';
import SocialProof from '@site/src/components/SocialProof';
import GettingStartedSection from '@site/src/components/GettingStartedSection';

import styles from './index.module.css';

function HomepageHeader() {
  return (
    <header className={styles.heroBanner}>
      <div>
        <h1 className={styles.heroTitle}>
          CoPilot
          <br />
          Collections
        </h1>
      </div>
      <div className={styles.heroRight}>
        <p className={styles.heroSub}>
          Stop switching between Jira, Figma, and your codebase. One framework.
          Every phase of delivery. AI at every step.
        </p>
        <div className={styles.heroActions}>
          <Link
            className={styles.btnPrimary}
            href="https://github.com/TheSoftwareHouse/copilot-collections"
            target="_blank"
            rel="noopener noreferrer"
          >
            See on GitHub
          </Link>
          <Link className={styles.btnSecondary} to="/docs/">
            Read the docs
          </Link>
        </div>
        <p className={styles.heroProof}>
          Built by The Software House · Used daily by 300+ engineers · 50+
          commercial projects
        </p>
      </div>
    </header>
  );
}

export default function Home(): React.JSX.Element {
  const { siteConfig } = useDocusaurusContext();

  return (
    <Layout
      title={siteConfig.title}
      description="AI-powered product engineering framework — specialized agents, structured workflows, and MCP integrations covering the full product lifecycle from ideation to delivery."
    >
      <HomepageHeader />
      <main>
        <div className={styles.divider} />
        <HomepageFeatures />
        <div className={styles.divider} />
        <SocialProof />
        <div className={styles.divider} />
        <WorkflowShowcase />
        <div className={styles.divider} />
        <QuickWins />
        <div className={styles.divider} />
        <GettingStartedSection />
      </main>
    </Layout>
  );
}
