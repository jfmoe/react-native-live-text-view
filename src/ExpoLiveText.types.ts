import { ViewProps } from 'react-native';

export type ChangeEventPayload = {
  value: string;
};

export interface ExpoLiveTextViewProps extends ViewProps {
  disabled?: boolean;
}
