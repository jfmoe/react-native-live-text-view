import { requireNativeViewManager } from 'expo-modules-core';
import * as React from 'react';
import { NativeSyntheticEvent } from 'react-native';

import {
  LiveTextViewProps,
  OnErrorEventData,
  OnHighlightChangeEventData,
  OnReadyEventData,
  OnTextSelectionChangeEventData,
} from './LiveText.types';

const NativeView = requireNativeViewManager('ExpoLiveText');

function withDeprecatedNativeEvent<NativeEvent>(
  event: NativeSyntheticEvent<NativeEvent>,
): NativeEvent {
  Object.defineProperty(event.nativeEvent, 'nativeEvent', {
    get() {
      console.warn(
        '[expo-live-text]: Accessing event payload through "nativeEvent" is deprecated, it is now part of the event object itself',
      );
      return event.nativeEvent;
    },
  });
  return event.nativeEvent;
}

export default function LiveTextView(props: LiveTextViewProps) {
  const onReady = (event: NativeSyntheticEvent<OnReadyEventData>) => {
    return props.onReady?.(withDeprecatedNativeEvent(event));
  };

  const onError = (event: NativeSyntheticEvent<OnErrorEventData>) => {
    return props.onError?.(withDeprecatedNativeEvent(event));
  };

  const onHighlightChange = (event: NativeSyntheticEvent<OnHighlightChangeEventData>) => {
    return props.onHighlightChange?.(withDeprecatedNativeEvent(event).isHighlight);
  };

  const onTextSelectionChange = (event: NativeSyntheticEvent<OnTextSelectionChangeEventData>) => {
    return props.onTextSelectionChange?.(withDeprecatedNativeEvent(event));
  };

  return (
    <NativeView
      {...props}
      onReady={onReady}
      onError={onError}
      onHighlightChange={onHighlightChange}
      onTextSelectionChange={onTextSelectionChange}
    />
  );
}
