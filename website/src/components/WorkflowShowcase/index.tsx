import React from 'react';
import SdlcDiagram from '@site/src/components/SdlcDiagram';

import styles from './styles.module.css';

export default function WorkflowShowcase(): React.JSX.Element {
  return (
    <section className={styles.flowSection}>
      <div className={styles.flowHeader}>
        <h2>
          This is the
          <br />
          new SDLC
        </h2>
        <p>
          Every phase of delivery restructured around how AI actually works —
          not bolted onto an existing process. From raw workshop transcripts to
          production-ready code.
        </p>
      </div>

      <div className={styles.flowCanvasWrap}>
        <SdlcDiagram />
      </div>

      <p className={styles.flowCaption}>
        Every step requires your review. The framework provides structure —
        judgment stays with your team. In Cursor, attach each <code>.md</code>{' '}
        prompt using <code>@</code> in chat or Agent (for example{' '}
        <code>@website/docs/prompts/public/eversis-implement.md</code>); they are
        not built-in <code>/</code> slash commands.
      </p>
    </section>
  );
}
