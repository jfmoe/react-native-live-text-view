import { ViewProps } from 'react-native';

export type OnReadyEvent = {
  text: string;
  hasResults: boolean;
  success: boolean;
};

export interface ExpoLiveTextViewProps extends ViewProps {
  disabled?: boolean;
  onReady?: (event: { nativeEvent: OnReadyEvent }) => void;
}
