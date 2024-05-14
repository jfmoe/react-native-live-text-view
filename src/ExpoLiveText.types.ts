import { ViewProps } from 'react-native';

export interface OnReadyEventData {
  hasResults: boolean;
  transcript: string;
}

export interface OnErrorEventData {
  error: string;
}

export interface OnTextSelectionChangeEventData {
  selectedText: string;
  hasActiveTextSelection: boolean;
}

export interface OnHighlightChangeEventData {
  visible: boolean;
}

export interface ExpoLiveTextViewProps extends ViewProps {
  disabled?: boolean;
  onStart?: () => void;
  onReady?: (event: OnReadyEventData) => void;
  onError?: (event: OnErrorEventData) => void;
  onHighlightChange?: (event: OnHighlightChangeEventData) => void;
  onTextSelectionChange?: (event: OnTextSelectionChangeEventData) => void;
}
