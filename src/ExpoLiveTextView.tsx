import { requireNativeViewManager } from 'expo-modules-core';
import * as React from 'react';

import { ExpoLiveTextViewProps } from './ExpoLiveText.types';

const NativeView: React.ComponentType<ExpoLiveTextViewProps> =
  requireNativeViewManager('ExpoLiveText');

export default function ExpoLiveTextView(props: ExpoLiveTextViewProps) {
  return <NativeView {...props} />;
}
