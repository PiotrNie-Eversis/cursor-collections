import React from "react";
import Link from "@docusaurus/Link";

import styles from "./styles.module.css";

const stats = [
  {
    num: "01",
    text: "Average lead time reduction: 30% — measured across 50+ commercial projects.",
  },
  {
    num: "02",
    text: "From juniors to principals. Full adoption across all seniority levels.",
  },
];

export default function SocialProof(): React.JSX.Element {
  return (
    <section className={styles.validated}>
      <div className={styles.validatedInner}>
        <div className={styles.validatedHeader}>
          <h2>
            <span className={styles.keepTogether}>30% faster delivery</span>
            <br />
            on average
          </h2>
          <Link className={styles.readMore} to="/docs/">
            Read the methodology →
          </Link>
        </div>
        <div className={styles.statsCards}>
          {stats.map((stat) => (
            <div key={stat.num} className={styles.statCard}>
              <span className={styles.statNum}>{stat.num}</span>
              <p>{stat.text}</p>
            </div>
          ))}
        </div>
      </div>
    </section>
  );
}
