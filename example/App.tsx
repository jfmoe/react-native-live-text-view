import { StyleSheet, Text, View } from 'react-native';

import * as ExpoLiveText from 'expo-live-text';

export default function App() {
  return (
    <View style={styles.container}>
      <Text>{ExpoLiveText.hello()}</Text>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#fff',
    alignItems: 'center',
    justifyContent: 'center',
  },
});
