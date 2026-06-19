import Link from "@docusaurus/Link";
import AnimationCanvas from "@site/src/components/HeroSection/AnimationCanvas";
import styles from "./index.module.css";

const HeroSection = () => {
  return (
    <div className={styles.heroBanner}>
      <AnimationCanvas />
      <div className={styles.heroContent}>
        <h1 className={styles.heroTitle}>
          Cursor
          <br />
          Collections
        </h1>
      </div>
      <div className={`${styles.heroRight} ${styles.heroContent}`}>
        <p className={styles.heroSub}>
          An opinionated <strong>Cursor-native</strong> product engineering
          framework — rules, prompts, MCP, and skills for the full SDLC.
          <br />
          <strong>Ideate → Implement → Review</strong> — with human gates at
          every step.
        </p>
        <div className={styles.heroActions}>
          <Link
            className={styles.btnPrimary}
            to="/docs/getting-started/start-here"
          >
            Get started
          </Link>
          <Link
            className={styles.btnSecondary}
            href="https://github.com/PiotrNie-Eversis/cursor-collections"
            target="_blank"
            rel="noopener noreferrer"
          >
            See on GitHub
          </Link>
        </div>
        <p className={styles.heroProof}>
          Maintained by Eversis · MIT · Cursor-native
        </p>
      </div>
    </div>
  );
};

export default HeroSection;
