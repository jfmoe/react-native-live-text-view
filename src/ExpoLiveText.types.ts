import { ViewProps } from 'react-native';

export interface OnReadyEvent {
  hasResults: boolean;
  transcript: string;
}

export interface OnErrorEvent {
  error: string;
}

export interface OnTextSelectionChangeEvent {
  selectedText: string;
  hasActiveTextSelection: boolean;
}

export interface ExpoLiveTextViewProps extends ViewProps {
  disabled?: boolean;
  onStart?: () => void;
  onReady?: (event: { nativeEvent: OnReadyEvent }) => void;
  onError?: (event: { nativeEvent: OnErrorEvent }) => void;
  onTextSelectionChange?: (event: { nativeEvent: OnTextSelectionChangeEvent }) => void;
}
