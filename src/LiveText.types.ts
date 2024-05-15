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
  isHighlight: boolean;
}

export interface LiveTextViewProps extends ViewProps {
  disabled?: boolean;
  liveActionButtonHidden?: boolean;
  onStart?: () => void;
  onReady?: (event: OnReadyEventData) => void;
  onError?: (event: OnErrorEventData) => void;
  onHighlightChange?: (isHighlight: boolean) => void;
  onTextSelectionChange?: (event: OnTextSelectionChangeEventData) => void;
}
