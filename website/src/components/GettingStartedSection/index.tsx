import React from "react";
import Link from "@docusaurus/Link";

import styles from "./styles.module.css";

const steps = [
  {
    num: 1,
    title: "Clone the repo",
    description: (
      <>
        <code>git clone [repo] cursor-collections</code> alongside your existing
        projects
      </>
    ),
  },
  {
    num: 2,
    title: "Open in Cursor",
    description: (
      <>
        Open the folder in <strong>Cursor</strong>, read <code>AGENTS.md</code>{" "}
        and the{" "}
        <Link to="/docs/framework">Framework reference</Link> in this
        site (or <code>documentation/cursor-collection.md</code> in the repo), and
        review <code>.cursor/rules/</code> (start with{" "}
        <code>eversis-agent-core.mdc</code>).
      </>
    ),
  },
  {
    num: 3,
    title: "Enable MCP servers",
    description: (
      <>
        The repo includes <code>.cursor/mcp.json</code>. When Cursor detects
        it, enable the suggested servers (Jira, Figma, Playwright, Context7,
        and more) from the UI.
      </>
    ),
  },
  {
    num: 4,
    title: "Run your first prompt",
    description: (
      <>
        In Chat or Agent, attach{" "}
        <code>@eversis-implement</code> and your
        ticket or task text.
      </>
    ),
  },
];

export default function GettingStartedSection(): React.JSX.Element {
  return (
    <section className={styles.gettingStarted}>
      <div className={styles.gettingStartedInner}>
        <div className={styles.leftCol}>
          <h2>
            Set up once.
            <br />
            Works across
            <br />
            every project.
          </h2>
          <p className={styles.sub}>
            Clone the repo, open it in Cursor, build{" "}
            <code>mcp/eversis-collections-mcp</code> and enable the{" "}
            <code>eversis-collections</code> MCP server, then attach{" "}
            <code>eversis-*.md</code> prompts with <code>@</code> in any project
            you configure.
          </p>
          <div className={styles.gsActions}>
            <Link
              className={styles.btnPrimary}
              href="https://github.com/PiotrNie-Eversis/cursor-collections"
              target="_blank"
              rel="noopener noreferrer"
            >
              Get the repo on GitHub
            </Link>
            <Link className={styles.btnSecondary} to="/docs/">
              Read the docs
            </Link>
          </div>
        </div>
        <div className={styles.steps}>
          {steps.map((step, idx) => (
            <div
              key={step.num}
              className={`${styles.step} ${idx === 0 ? styles.stepFirst : ""} ${idx === steps.length - 1 ? styles.stepLast : ""}`}
            >
              <div className={styles.stepNum}>{step.num}</div>
              <div className={styles.stepContent}>
                <h4>{step.title}</h4>
                <p>{step.description}</p>
              </div>
            </div>
          ))}
        </div>
      </div>
    </section>
  );
}
