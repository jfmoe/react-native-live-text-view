import { ViewProps } from 'react-native';

export type OnReadyEvent = {
  transcript: string;
  hasResults: boolean;
};

export interface ExpoLiveTextViewProps extends ViewProps {
  disabled?: boolean;
  onReady?: (event: { nativeEvent: OnReadyEvent }) => void;
}
