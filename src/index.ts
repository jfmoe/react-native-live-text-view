import { NativeModulesProxy, EventEmitter, Subscription } from 'expo-modules-core';

// Import the native module. On web, it will be resolved to ExpoLiveText.web.ts
// and on native platforms to ExpoLiveText.ts
import ExpoLiveTextModule from './ExpoLiveTextModule';
import ExpoLiveTextView from './ExpoLiveTextView';
import { ChangeEventPayload, ExpoLiveTextViewProps } from './ExpoLiveText.types';

// Get the native constant value.
export const PI = ExpoLiveTextModule.PI;

export function hello(): string {
  return ExpoLiveTextModule.hello();
}

export async function setValueAsync(value: string) {
  return await ExpoLiveTextModule.setValueAsync(value);
}

const emitter = new EventEmitter(ExpoLiveTextModule ?? NativeModulesProxy.ExpoLiveText);

export function addChangeListener(listener: (event: ChangeEventPayload) => void): Subscription {
  return emitter.addListener<ChangeEventPayload>('onChange', listener);
}

export { ExpoLiveTextView, ExpoLiveTextViewProps, ChangeEventPayload };
