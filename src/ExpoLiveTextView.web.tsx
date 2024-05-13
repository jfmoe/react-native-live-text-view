import * as React from 'react';

import { ExpoLiveTextViewProps } from './ExpoLiveText.types';

export default function ExpoLiveTextView(props: ExpoLiveTextViewProps) {
  return (
    <div>
      <span>{props.name}</span>
    </div>
  );
}
