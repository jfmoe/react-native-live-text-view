import { ViewProps } from 'react-native';

export type OnReadyEvent = {
  hasResults: boolean;
  transcript: string;
};

export type OnErrorEvent = {
  error: string;
};

export interface ExpoLiveTextViewProps extends ViewProps {
  disabled?: boolean;
  onStart?: () => void;
  onReady?: (event: { nativeEvent: OnReadyEvent }) => void;
  onError?: (event: { nativeEvent: OnErrorEvent }) => void;
}
