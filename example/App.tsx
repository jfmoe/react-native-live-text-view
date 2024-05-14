import * as ImagePicker from 'expo-image-picker';
import { ExpoLiveTextView } from 'expo-live-text';
import { useState } from 'react';
import { StyleSheet, Image, View, Button } from 'react-native';

export default function App() {
  const [image, setImage] = useState<string | null>(null);
  const [disabled, setDisabled] = useState(false);

  const pickImage = async () => {
    const result = await ImagePicker.launchImageLibraryAsync({
      mediaTypes: ImagePicker.MediaTypeOptions.All,
      allowsEditing: true,
      quality: 1,
    });

    if (result.canceled) return;

    setImage(result.assets[0].uri);
  };

  return (
    <View style={styles.container}>
      <Button title="Pick an image" onPress={pickImage} />
      {image && (
        <>
          <Button title="toggleLiveTextDisabled" onPress={() => setDisabled(v => !v)} />
          <ExpoLiveTextView
            disabled={disabled}
            onStart={() => console.log('Image analyze start')}
            onReady={({ nativeEvent }) =>
              console.log(`Image analyze result: ${JSON.stringify(nativeEvent)}`)
            }
            onError={({ nativeEvent }) => console.log(`Image analyze error: ${nativeEvent.error}`)}
            onTextSelectionChange={({ nativeEvent }) =>
              console.log(
                `hasActiveTextSelection: ${nativeEvent.hasActiveTextSelection}`,
                `selectedText: ${nativeEvent.selectedText}`,
              )
            }
          >
            <Image source={{ uri: image }} style={styles.image} />
          </ExpoLiveTextView>
        </>
      )}
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
  image: {
    width: 300,
    height: 300,
  },
});
